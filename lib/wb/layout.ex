defmodule WB.Layout do
  require Logger

  alias WB.Resources.Document
  alias WB.Resources.Dir
  alias WB.XmasTree

  defstruct resources: [], root: nil

  defmodule Templates do
    defstruct [:index, :single, :main]
  end

  def read(root) do
    root_templates = templates_for(root)

    resources =
      root
      |> list_resources(root_templates)
      |> build_refs()

    %__MODULE__{
      resources: [
        Dir.new(root, root, root_templates)
        | resources
      ],
      root: root
    }
  end

  def doc_by_path(%__MODULE__{} = layout, path) do
    needle =
      if Path.type(path) == :relative do
        Path.join(layout.root, path)
      else
        path
      end

    layout
    |> docs()
    |> Enum.find(fn
      %{path: ^needle} -> true
      _ -> false
    end)
  end

  def any_by_path(%{resources: resources, root: root}, path) do
    needle =
      if Path.type(path) == :relative do
        Path.join(root, path)
      else
        path
      end

    Enum.find(
      resources,
      fn
        %{path: ^needle} -> true
        _ -> false
      end
    )
  end

  def list_children(%__MODULE__{resources: resources}, %Dir{} = dir) do
    children(resources, dir)
  end

  def backlinks(%__MODULE__{} = layout, %Document{} = doc) do
    layout
    |> docs()
    |> Enum.filter(fn d ->
      doc.path in Enum.map(d.refs, &elem(&1, 1))
    end)
  end

  def docs(%__MODULE__{resources: resources}), do: docs(resources)

  def docs(resources) when is_list(resources) do
    Enum.filter(resources, fn
      %Document{} -> true
      _ -> false
    end)
  end

  defp build_refs(resources) do
    Enum.map(resources, fn doc ->
      patch_refs(doc, resources)
    end)
  end

  defp patch_refs(%Document{links: [_ | _] = links} = doc, resources) do
    refs =
      links
      |> Enum.reduce([], fn {match, target}, acc ->
        with {:ok, found} <- find_ref(target, doc, resources) do
          [{match, found} | acc]
        else
          {:error, :not_found} ->
            XmasTree.warn(
              "Dead link detected.",
              "Could not find reference for '#{match}' in #{doc.path}"
            )

            acc
        end
      end)
      |> Enum.reverse()

    %{doc | refs: refs}
  end

  defp patch_refs(no_links_entity, _), do: no_links_entity

  defp find_ref(target, doc, resources) do
    target_uri = URI.parse(target)
    closest_to_doc = Path.join(doc.dirname, target_uri.path)

    cond do
      Path.extname(closest_to_doc) == ".md" and File.exists?(closest_to_doc) ->
        {:ok, closest_to_doc}

      File.exists?(closest_to_doc <> ".md") ->
        {:ok, closest_to_doc <> ".md"}

      File.dir?(closest_to_doc) ->
        {:ok, closest_to_doc}

      by_basename = find_doc_by_basename(resources, target_uri.path) ->
        {:ok, by_basename.path}

      by_basename = find_dir_by_basename(resources, target_uri.path) ->
        {:ok, by_basename.path}

      true ->
        with {:ok, _} = success <- liberal_search(target, resources) do
          success
        else
          _ ->
            {:error, :not_found}
        end
    end
  end

  defp liberal_search(needle, resources) do
    sanitized_needle =
      needle
      |> String.replace(" ", "")
      |> String.downcase()

    resources
    |> docs()
    |> Enum.find_value(fn doc ->
      sanitized_title =
        doc.title
        |> String.replace(" ", "")
        |> String.downcase()

      if sanitized_title == sanitized_needle do
        {:ok, doc.path}
      end
    end)
  end

  defp list_resources(dir, inherited_templates) do
    list_resources(dir, dir, inherited_templates)
  end

  defp list_resources(dir, root, inherited_templates) do
    dir
    |> File.ls!()
    |> Enum.reduce([], fn f, acc ->
      path = Path.join(dir, f)

      cond do
        File.dir?(path) ->
          templates = templates_for(path, inherited_templates)
          [Dir.new(path, root, templates) | list_resources(path, root, templates)] ++ acc

        File.regular?(path) and Path.extname(path) == ".md" ->
          templates = templates_for(path, inherited_templates)

          [Document.new(path, root, templates) | acc]

        true ->
          acc
      end
    end)
  end

  defp templates_for(path, inherited_templates \\ %Templates{}) do
    inherited_templates
    |> maybe_update_templates(:main, path)
    |> maybe_update_templates(:index, path)
    |> maybe_update_templates(:single, path)
  end

  defp maybe_update_templates(%Templates{} = t, kind, path) do
    tpl = Path.join(path, "_#{kind}.html")

    if File.exists?(tpl) do
      Map.put(t, kind, tpl)
    else
      t
    end
  end

  defp children(resources, %Dir{} = dir) when is_list(resources) do
    resources
    |> Enum.filter(fn
      %Dir{} = scanning ->
        scanning.reldir == dir.relpath and scanning != dir

      %Document{} = scanning ->
        scanning.reldir == dir.relpath
    end)
  end

  defp find_doc_by_basename(resources, needle) when is_list(resources) do
    Enum.find(
      resources,
      fn
        %Document{basename: ^needle} -> true
        _ -> false
      end
    )
  end

  def find_dir_by_basename(resources, needle) when is_list(resources) do
    Enum.find(
      resources,
      fn
        %Dir{basename: ^needle} -> true
        _ -> false
      end
    )
  end
end
