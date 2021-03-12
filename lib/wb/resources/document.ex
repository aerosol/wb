defmodule WB.Resources.Document do
  alias WB.Resources.Document.FrontMatter
  alias WB.Resources.Document.Link

  defstruct path: nil,
            templates: nil,
            relpath: nil,
            title: nil,
            links: [],
            refs: [],
            raw: nil,
            basename: nil,
            dirname: nil,
            reldir: nil,
            root: nil,
            render: nil,
            front_matter: nil

  @link_re ~r/\[\[(?<link>[[:alnum:]\s\.\/\-\_]+)([\|]{1}(?<title>[[:alnum:]\s\.\-\_]+))?\]\]/m

  def new(path, root, templates) do
    root = Path.expand(root)
    path = Path.absname(path)

    {front_matter, raw} =
      path
      |> File.read!()
      |> FrontMatter.extract()

    dirname = Path.dirname(path)
    basename = Path.basename(path, ".md")
    reldir = Path.dirname(relative_to(path, root))
    relpath = Path.join(reldir, basename)

    %__MODULE__{
      path: path,
      relpath: relpath,
      root: root,
      templates: templates,
      links: extract_links(raw),
      title: extract_title(front_matter, raw, basename),
      basename: basename,
      dirname: dirname,
      raw: raw,
      reldir: reldir,
      front_matter: front_matter
    }
  end

  def extract_title(%{"title" => title}, _, _) do
    title
  end

  def extract_title(_, body, default) do
    body
    |> String.split("\n", trim: true)
    |> Enum.find_value(default, fn
      "# " <> title -> title
      _ -> false
    end)
  end

  def extract_links(body) when is_binary(body) do
    @link_re
    |> Regex.scan(body)
    |> Enum.map(fn
      [match, target] ->
        Link.new(target: target, match: match)

      [match, target, _, title] ->
        Link.new(target: target, match: match, title: title)
    end)
  end

  # https://github.com/elixir-lang/elixir/pull/10586
  defp relative_to(dirname, dirname), do: "."

  defp relative_to(dirname, root) do
    Path.relative_to(dirname, root)
  end
end
