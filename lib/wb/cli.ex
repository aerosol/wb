defmodule WB.CLI do
  alias WB.Templates
  alias WB.XmasTree

  @moduledoc """
  Writer's Block

  Usage:

      wb [command]

  Available commands:

      wb new [layout_root]
      wb gen [layout_root] [build_root] [target_domain]

  Examples:

      wb new my-wiki
      wb gen my-wiki /tmp/my-wiki-dev # and navigate to file:///tmp/my-wiki-dev/index.html
      wb gen my-wiki /tmp/my-wiki-prod https://example.com
  """

  def main(args) do
    case parse(args) do
      {[], ["new", layout_root], []} ->
        new(layout_root)

      {[], ["gen", layout_root, build_root], []} ->
        generate(layout_root, build_root, "file://" <> build_root)

      {[], ["gen", layout_root, build_root, domain], []} ->
        generate(layout_root, build_root, domain)

      _ ->
        help()
    end
  end

  defp help() do
    IO.puts(@moduledoc)
  end

  defp parse(args) do
    OptionParser.parse(args, strict: [debug: :boolean])
  end

  defp new(layout_root) do
    XmasTree.info("Initializing new site at #{layout_root}")
    :ok = File.mkdir_p!(layout_root)
    :ok = File.write!(Path.join(layout_root, "_index.html"), Templates.Defaults.index())
    :ok = File.write!(Path.join(layout_root, "_main.html"), Templates.Defaults.main())
    :ok = File.write!(Path.join(layout_root, "_single.html"), Templates.Defaults.single())
    :ok = File.write!(Path.join(layout_root, "hello.md"), Templates.Defaults.hello(layout_root))
    :ok = File.mkdir_p!(Path.join(layout_root, "_static/css"))
    :ok = File.mkdir_p!(Path.join(layout_root, "_static/fonts"))

    :ok =
      File.write!(
        Path.join(layout_root, "_static/css/mvp.css"),
        Templates.Defaults.stylesheet()
      )

    XmasTree.success(
      "Done! To generate run:",
      "wb gen #{layout_root} /tmp/test"
    )
  end

  defp generate(layout_root, build_root, domain) do
    templates = [
      "_index.html",
      "_single.html",
      "_main.html"
    ]

    templates_present? = Enum.all?(templates, &File.exists?(Path.join(layout_root, &1)))

    if templates_present? do
      layout_root
      |> WB.Layout.read()
      |> WB.Renderer.render_layout(build_root, domain)
    else
      XmasTree.warn("Make sure templates exist in #{layout_root}", "Perhaps run `wb new` first?")
      System.stop(1)
    end
  end
end
