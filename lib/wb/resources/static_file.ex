defmodule WB.Resources.StaticFile do
  defstruct path: nil,
            basename: nil,
            dirname: nil,
            reldir: nil,
            relpath: nil,
            root: nil,
            type: nil

  def new(path, root) do
    root = Path.expand(root)
    path = Path.absname(path)

    basename = Path.basename(path)
    dirname = Path.dirname(path)
    reldir = Path.dirname(relative_to(path, root))
    relpath = Path.join(reldir, basename)
    type = Path.extname(path) |> String.downcase()

    false = String.starts_with?(basename, "_")

    %__MODULE__{
      basename: basename,
      dirname: dirname,
      path: path,
      reldir: reldir,
      relpath: relpath,
      root: root,
      type: type
    }
  end

  # https://github.com/elixir-lang/elixir/pull/10586
  defp relative_to(dirname, dirname), do: "."

  defp relative_to(dirname, root) do
    Path.relative_to(dirname, root)
  end
end
