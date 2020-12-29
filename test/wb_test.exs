defmodule WbTest do
  use ExUnit.Case

  alias WB.Layout

  setup do
    rand =
      ?A..?Z
      |> Enum.concat(?a..?z)
      |> Enum.shuffle()
      |> Enum.take(12)

    root = Path.join(System.tmp_dir!(), "#{__MODULE__}-#{rand}")

    on_exit(fn ->
      true = String.starts_with?(root, System.tmp_dir!())
      true = String.contains?(root, "#{__MODULE__}")
      File.rm_rf!(root)
    end)

    %{
      root: root
    }
  end

  test "builds documents list from a filesystem tree", %{root: root} do
    sample_layout = [
      {"index.md", "# This is my index"},
      {"extras/index2.md", "# This is my extra index"},
      {"extras/subdir/index3.md", "# Third index"}
    ]

    mklayout(sample_layout, root)

    assert %{resources: [root_dir, d1, extras_dir, d2, subdir, _], root: ^root} =
             Layout.read(root)

    assert d1.raw == "# This is my index"
    assert d1.links == []
    assert d1.refs == []
    assert d1.basename == "index"
    assert d1.title
    assert d1.path == Path.join(root, "index.md")
    assert d1.dirname == root
    assert d1.reldir == "."
    assert d1.relpath == "./index"

    assert root_dir.path == root
    assert root_dir.relpath == "."

    assert d2.raw == "# This is my extra index"
    assert d2.links == []
    assert d2.refs == []
    assert d2.basename == "index2"
    assert d2.title
    assert d2.path == Path.join(root, "extras/index2.md")
    assert d2.dirname == Path.join(root, "extras")
    assert d2.reldir == "extras"
    assert d2.relpath == "extras/index2"

    assert extras_dir.path == Path.join(root, "extras")
    assert extras_dir.relpath == "extras"

    assert subdir.relpath == "extras/subdir"
    assert subdir.reldir == "extras"
  end

  test "1st level neighbours can be retrieved", %{root: root} do
    sample_layout = [
      {"index.md", ""},
      {"alice/about_alice.md", ""},
      {"alice/alice_notes.md", ""},
      {"bob/carol/baz.md", ""},
      {"bob/carol/a.md", ""},
      {"bob/carol/alice/relationship.md", ""},
      {"chuck/foo.md", ""}
    ]

    mklayout(sample_layout, root)
    assert layout = Layout.read(root)

    [first_dir | _] = layout.resources

    children = Layout.list_children(layout, first_dir)

    [_, %{basename: "alice"} = alice | _] = children

    assert Enum.map(Layout.list_children(layout, alice), & &1.basename) == [
             "about_alice",
             "alice_notes"
           ]

    assert Enum.map(children, & &1.basename) == [
             "index",
             "alice",
             "bob",
             "chuck"
           ]
  end

  test "titles are fetched from first paragraph", %{root: root} do
    sample_layout = [
      {"foo.md", "# foo"},
      {"bar.md", "# Bar Baz"},
      {"bam.md",
       """
       ---
       some garbage
       ---

       ## Misplaced header

       # Hello world

       Contents
       """},
      {"notitle.md", "Some text"}
    ]

    mklayout(sample_layout, root)

    assert layout = Layout.read(root)
    assert length(layout.resources) == 5

    assert Layout.doc_by_path(layout, "foo.md").title == "foo"
    assert Layout.doc_by_path(layout, "bar.md").title == "Bar Baz"
    assert Layout.doc_by_path(layout, "bam.md").title == "Hello world"
    assert Layout.doc_by_path(layout, "notitle.md").title == "Untitled"
  end

  test "templates are tracked", %{root: root} do
    sample_layout = [
      {"_index.html", "<!-- whatever -->"},
      {"_single.html", "<!-- whatever -->"},
      {"index.md", "Main Index"},
      {"foo/index.md", "Foo Index"},
      {"bar/index.md", "Bar Index"},
      {"bar/_index.html", "<!-- whatever -->"},
      {"bar/baz/index.md", "Bar Baz Index"}
    ]

    mklayout(sample_layout, root)

    assert layout = Layout.read(root)

    main_index = Path.join(root, "_index.html")
    main_single = Path.join(root, "_single.html")
    bar_index = Path.join(root, "bar/_index.html")

    assert %{index: ^main_index, single: ^main_single} =
             Layout.doc_by_path(layout, "index.md").templates

    assert %{index: ^main_index, single: ^main_single} =
             Layout.doc_by_path(layout, "foo/index.md").templates

    assert %{index: ^bar_index, single: ^main_single} =
             Layout.doc_by_path(layout, "bar/index.md").templates

    assert %{index: ^bar_index, single: ^main_single} =
             Layout.doc_by_path(layout, "bar/baz/index.md").templates
  end

  test "wiki-style links are tracked", %{root: root} do
    # FIXME: prevent leaving the root dir
    sample_layout = [
      {"onefile.md",
       """
       Wiki-style Link: [[link1]]
       Wiki-style Link 2: [[CamelCaseLink]]
       Wiki-style Link 3: [[Some link]]
       Wiki-style Relative Link: [[../path/link.md]]
       """}
    ]

    mklayout(sample_layout, root)
    assert layout = Layout.read(root)

    assert doc = Layout.doc_by_path(layout, "onefile.md")

    assert doc.links == [
             {"[[link1]]", "link1"},
             {"[[CamelCaseLink]]", "CamelCaseLink"},
             {"[[Some link]]", "Some link"},
             {"[[../path/link.md]]", "../path/link.md"}
           ]

    assert doc.refs == []
  end

  test "backlinks can be retrieved", %{root: root} do
    sample_layout = [
      {"foo.md", "Say [[hello]]"},
      {"hello.md", "Hello world!"},
      {"bar.md", "[[hello]] world"}
    ]

    mklayout(sample_layout, root)
    assert layout = Layout.read(root)

    doc = Layout.doc_by_path(layout, "hello.md")

    backlinks = Layout.backlinks(layout, doc)

    assert length(backlinks) == 2
    assert Enum.at(backlinks, 0).basename == "foo"
    assert Enum.at(backlinks, 1).basename == "bar"
  end

  test "for wiki-style links, refs are resolved", %{root: root} do
    sample_layout = [
      {"index.md",
       """
       [[foo.md]]
       [[CamelFile]]
       [[bar]]
       [[TitleNotFound]]
       [[ThisIsTheTitle]]
       [[baz/bam]]
       """},
      {"foo.md", "Foo"},
      {"bar.md", "Bar"},
      {"CamelFile.md", "Camel"},
      {"baz/some.md", "# This is The Title"},
      {"baz/bam.md", "This is bam!"}
    ]

    mklayout(sample_layout, root)
    assert layout = Layout.read(root)

    assert %{refs: [{_, r1}, {_, r2}, {_, r3}, {_, r4}, {_, r5}]} =
             Layout.doc_by_path(layout, "index.md")

    assert r1 == "#{root}/foo.md"
    assert r2 == "#{root}/CamelFile.md"
    assert r3 == "#{root}/bar.md"
    assert r4 == "#{root}/baz/some.md"
    assert r5 == "#{root}/baz/bam.md"
  end

  # describe "Renderer" do
  # import WB.Renderer

  # test "links render", %{root: root} do
  # sample_layout = [
  # {"root.md", "Root node"},
  # {"foo/bar/baz.md", "Say [[hello]]"},
  # {"foo/bar/hello.md", "# Hello world!"}
  # ]

  # mklayout(sample_layout, "wiki")

  # assert renderer = WB.Renderer.render(root, "wiki/../_build")
  # end
  # end

  defp mklayout(layout, root) do
    true = String.starts_with?(root, System.tmp_dir!())
    true = String.contains?(root, "#{__MODULE__}")

    Enum.each(layout, fn {f, content} ->
      full_path = Path.join(root, f)
      :ok = File.mkdir_p!(Path.dirname(full_path))
      :ok = File.write!(full_path, content)
    end)

    :ok
  end
end
