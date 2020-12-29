defmodule WB.Resources.Dir do
  defstruct path: nil,
            templates: nil,
            reldir: nil,
            relpath: nil,
            root: nil,
            basename: nil,
            has_index?: false,
            render: nil

  def new(path, root, templates) do
    root = Path.expand(root)
    path = Path.expand(path)
    basename = Path.basename(path)

    has_index? = File.exists?(Path.join(path, "index.md"))

    %__MODULE__{
      path: path,
      templates: templates,
      basename: basename,
      reldir: Path.dirname(relative_to(path, root)),
      relpath: relative_to(path, root),
      root: root,
      has_index?: has_index?
    }
  end

  # https://github.com/elixir-lang/elixir/pull/10586
  defp relative_to(dirname, dirname), do: "."

  defp relative_to(dirname, root) do
    Path.relative_to(dirname, root)
  end
end
