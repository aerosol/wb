defmodule WB.Resources.StaticDir do
  defstruct path: nil,
            reldir: nil,
            relpath: nil,
            root: nil,
            basename: nil

  def new(path, root) do
    root = Path.expand(root)
    path = Path.expand(path)
    basename = Path.basename(path)

    true = String.starts_with?(basename, "_")

    %__MODULE__{
      path: path,
      basename: basename,
      reldir: Path.dirname(relative_to(path, root)),
      relpath: relative_to(path, root),
      root: root
    }
  end

  # https://github.com/elixir-lang/elixir/pull/10586
  defp relative_to(dirname, dirname), do: "."

  defp relative_to(dirname, root) do
    Path.relative_to(dirname, root)
  end
end
