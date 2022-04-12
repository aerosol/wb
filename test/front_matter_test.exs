defmodule FrontMatterTest do
  use ExUnit.Case

  alias WB.Resources.Document.FrontMatter

  test "parse front matter" do
    data = """
    title:  The title
    hello: world
    tags: 
     - life
     - universe
     - everything
    ---
    Body
    """

    assert {%{
              "title" => "The title",
              "hello" => "world",
              "tags" => ["life", "universe", "everything"]
            }, "Body\n"} = FrontMatter.extract(data)
  end

  test "parse front matter with double markers" do
    data = """
    ---
    title: A thing
    ---
    Body
    """

    assert {%{
              "title" => "A thing"
            }, _} = FrontMatter.extract(data)
  end

  test "doesnt crash if --- markers are in the document but don't indicate front matter" do
    data = """
    # How to use

    Try to put a front-matter:
    ```markdown
    ---
    title: foo
    ---
    ```
    """

    assert {%{}, _} = FrontMatter.extract(data)
  end

  test "excessive separators are ignored" do
    data = """
    ---
    title: foo
    ---

    Hello

    ---
    title: bar
    ---

    ```
    ---
    title: baz
    ---
    ```
    """

    assert {%{"title" => "foo"}, _} = FrontMatter.extract(data)
  end
end
