defmodule WB.Templates do
  defmacro __using__(_opts) do
    quote do
      import WB.Templates
    end
  end

  def fingerprint(term) do
    :sha256
    |> :crypto.hash(:erlang.term_to_binary(term))
    |> Base.encode16(case: :lower)
    |> String.slice(0, 8)
  end

  def breadcrumbs(relpath, domain) do
    splits =
      relpath
      |> Path.relative_to(".")
      |> Path.split()

    crumbs =
      1..length(splits)
      |> Enum.map(&Enum.take(splits, &1))
      |> Enum.drop(-1)
      |> Enum.map(fn p ->
        {Path.join([domain, Path.join(p), "index.html"]), List.last(p)}
      end)

    permalink_href = Path.join(domain, relpath <> ".html")

    case List.last(crumbs) do
      {^permalink_href, _} ->
        crumbs

      _ ->
        Enum.concat(crumbs, [{permalink_href, "permalink"}])
    end
  end
end
