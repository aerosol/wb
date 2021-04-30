defmodule WB.Resources.StaticFile do
  defstruct path: nil,
            basename: nil,
            dirname: nil,
            reldir: nil,
            relpath: nil,
            root: nil,
            type: nil,
            meta: nil,
            image?: false

  def new(path, root) do
    root = Path.expand(root)
    path = Path.absname(path)

    basename = Path.basename(path)
    dirname = Path.dirname(path)
    reldir = Path.dirname(relative_to(path, root))
    relpath = Path.join(reldir, basename)
    type = Path.extname(path) |> String.downcase()

    image? = type in [".jpeg", ".jpg", ".png"]
    exif = if image?, do: read_exif(path)

    false = String.starts_with?(basename, "_")

    %__MODULE__{
      basename: basename,
      dirname: dirname,
      path: path,
      reldir: reldir,
      relpath: relpath,
      root: root,
      type: type,
      image?: image?,
      meta: exif
    }
  end

  # https://github.com/elixir-lang/elixir/pull/10586
  defp relative_to(dirname, dirname), do: "."

  defp relative_to(dirname, root) do
    Path.relative_to(dirname, root)
  end

  defp read_exif(path) do
    with {:ok, exif} <- Exexif.exif_from_jpeg_file(path) do
      exif
    else
      _ ->
        nil
    end
  end
end
