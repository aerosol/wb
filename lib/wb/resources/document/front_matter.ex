defmodule WB.Resources.Document.FrontMatter do
  def extract(data) do
    with [meta, content] <- String.split(data, "---\n", trim: true, parts: 2),
         {:ok, yaml} <- YamlElixir.read_from_string(meta) do
      {yaml, content}
    else
      _ ->
        {%{}, data}
    end
  end
end
