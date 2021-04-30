defmodule WB.Renderer do
  alias WB.Layout
  alias WB.Resources.Dir
  alias WB.Resources.Document
  alias WB.Resources.StaticDir
  alias WB.Resources.StaticFile
  alias WB.XmasTree

  def render_layout(%Layout{} = layout, out_root, domain \\ "/") do
    layout
    |> Map.fetch!(:resources)
    |> Enum.map(fn
      %Document{} = document -> render_document(document, layout, domain)
      %StaticFile{} = file -> file
      %StaticDir{} = dir -> dir
      %Dir{} = dir -> render_dir(dir, layout, domain)
    end)
    |> save(out_root)

    XmasTree.success("Generated site for domain: #{domain}", "Files saved to #{out_root}")
  end

  def render_dir(%Dir{} = dir, %Layout{} = layout, domain) do
    if not dir.has_index? do
      children =
        layout
        |> Layout.list_children(dir)
        |> Enum.reduce(%{docs: [], dirs: [], files: [], images: []}, fn
          %Document{title: title, relpath: relpath}, acc ->
            %{
              acc
              | docs: [
                  %{title: title, href: Path.join(domain, relpath <> ".html")} | acc.docs
                ]
            }

          %Dir{basename: basename, relpath: relpath}, acc ->
            %{acc | dirs: [%{name: basename, href: Path.join(domain, relpath)} | acc.dirs]}

          %StaticFile{image?: false, basename: basename, relpath: relpath}, acc ->
            %{
              acc
              | files: [
                  %{name: basename, href: Path.join(domain, relpath)} | acc.files
                ]
            }

          %StaticFile{image?: true, basename: basename, relpath: relpath, meta: meta}, acc ->
            %{
              acc
              | images: [
                  %{name: basename, href: Path.join(domain, relpath), meta: meta} | acc.images
                ]
            }
        end)

      XmasTree.warn("Dir #{dir.reldir} has no index.", inspect(children))

      common_assigns = [
        domain: domain,
        basename: dir.basename,
        reldir: dir.reldir,
        relpath: Path.join(dir.relpath, "index")
      ]

      index =
        EEx.eval_file(dir.templates.index,
          assigns: [{:children, children} | common_assigns]
        )

      render = EEx.eval_file(dir.templates.main, assigns: [{:inner_html, index} | common_assigns])

      %{dir | render: render}
    else
      dir
    end
  end

  def render_document(%Document{} = document, %Layout{} = layout, domain) do
    html =
      document
      |> expand_links(layout, domain)
      |> expand_emojis()
      |> EEx.eval_string()
      |> Earmark.as_html!(footnotes: true)

    common_assigns = [
      domain: domain,
      basename: document.basename,
      reldir: document.reldir,
      relpath: document.relpath
    ]

    backlinks =
      layout
      |> Layout.backlinks(document)
      |> Enum.map(fn backlinking_doc ->
        {Path.join(domain, backlinking_doc.relpath <> ".html"), backlinking_doc.title}
      end)

    single =
      EEx.eval_file(document.templates.single,
        assigns: [
          {:inner_html, html},
          {:doc, document},
          {:backlinks, backlinks} | common_assigns
        ]
      )

    render =
      EEx.eval_file(document.templates.main,
        assigns: [{:inner_html, single}, {:doc, document} | common_assigns]
      )

    %{document | render: render}
  end

  def save(resources, out_root) do
    :ok = File.mkdir_p!(out_root)

    resources
    |> Enum.each(fn
      %Dir{} = dir ->
        dest = Path.join([out_root, dir.relpath])
        XmasTree.info("Creating dir", dest)
        File.mkdir_p!(dest)

        if dir.render do
          dest = Path.join(dest, "index.html")
          XmasTree.info("Rendering index", dest)
          File.write!(dest, dir.render)
        end

      %Document{} = document ->
        dest =
          Path.join([
            out_root,
            document.relpath <> ".html"
          ])

        XmasTree.info("Rendering document", dest)

        File.write!(
          dest,
          document.render
        )

      %StaticFile{} = file ->
        File.mkdir_p!(file.reldir)
        source = file.path
        dest = Path.join([out_root, file.reldir, file.basename])
        XmasTree.info("Copying file verbatim #{source}", dest)
        File.copy!(source, dest)

      %StaticDir{} = dir ->
        source = dir.path
        dest = Path.join([out_root, dir.relpath])
        XmasTree.info("Copying static directory verbatim #{source}", dest)
        File.cp_r!(source, dest)
    end)
  end

  def expand_emojis(raw) do
    emoji_re = ~r/\:(?<short_name>[a-zA-Z0-9+-_]+)\:/
    scan_result = Regex.scan(emoji_re, raw)

    Enum.reduce(scan_result, raw, fn [match, short_name], acc ->
      emoji = Exmoji.from_short_name(short_name)

      if emoji do
        String.replace(acc, match, Exmoji.EmojiChar.render(emoji))
      else
        acc
      end
    end)
  end

  def expand_links(doc, layout, domain) do
    Enum.reduce(doc.refs, doc.raw, fn link, acc ->
      href =
        layout
        |> Layout.any_by_path(link.ref)
        |> to_link(domain, link.title)

      String.replace(acc, link.match, href)
    end)
  end

  defp to_link(%Document{} = doc, domain, title) do
    title = title || doc.title

    """
    [#{title}](#{Path.join(domain, doc.relpath)}.html)
    """
    |> String.trim()
  end

  defp to_link(%Dir{} = dir, domain, title) do
    title = title || dir.basename

    """
    [#{title}](#{Path.join([domain, dir.relpath, "index.html"])})
    """
    |> String.trim()
  end
end
