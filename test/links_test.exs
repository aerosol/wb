defmodule LinksTest do
  use ExUnit.Case

  alias WB.Resources.Document.Link
  alias WB.Resources.Document

  test "works" do
    assert [%Link{title: nil, target: "hello", match: "[[hello]]"}] =
             Document.extract_links("[[hello]]")

    assert [%Link{title: nil, target: "Very Cruel", match: "[[Very Cruel]]"}] =
             Document.extract_links("Hello [[Very Cruel]] World")

    assert [
             %Link{
               title: "Overridden Title",
               target: "link",
               match: "[[link|Overridden Title]]"
             }
           ] = Document.extract_links("Some [[link|Overridden Title]]")
  end
end