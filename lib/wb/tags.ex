defmodule WB.Tags do
  require Logger
  alias WB.Layout
  alias WB.Resources.Document

  def write(%Layout{} = layout) do
    Logger.debug("Mapping tags...")

    docs_by_tag = docs_by_tag(layout)

    Enum.each(docs_by_tag, fn {tag, docs} ->
      Logger.debug("Writing tag index: #{tag} (#{Enum.count(docs)})")
      dest_dir = "#{layout.root}/tags/#{tag}"
      File.mkdir_p!(dest_dir)

      docs_index =
        Enum.map(docs, fn doc ->
          """
          # ##{tag}

            - [[#{doc.title}]]
          """
        end)
        |> Enum.join()

      File.write!(Path.join([dest_dir, "index.md"]), docs_index)
    end)

    layout
  end

  def docs_by_tag(layout) do
    Enum.reduce(
      layout.resources,
      %{},
      fn
        %Document{tags: [_ | _] = tags} = doc, acc ->
          Enum.reduce(tags, acc, fn tag, acc ->
            Map.update(acc, tag, [doc], fn existing_list ->
              [doc | existing_list]
            end)
          end)

        _, acc ->
          acc
      end
    )
  end
end
