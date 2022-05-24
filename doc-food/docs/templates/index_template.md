# Index template

Index template is stored in `_index.html` file.
It is the inner HTML, rendered within [[Main Template]] for automatically
indexed directories. The indexing happens only if a directory contains to
`index.md` file.

## Assings

Template assigns available are [^1]:

  - `@children` - a map with the following keys:
    - `docs` - two-element tuples consisting of document's `href` and `title`
    - `dirs` - two-element tuples consisting of directory's `href` and `name`
    - `files` - a list of [[static files]] in the form of two-element tuples consisting of static file's `href` and `name`
  - `@domain` - the target domain used for site generation. Can be used for
    building absolute links.
  - `@reldir` - relative directory of the index
  - `@relpath` - relative path of the index

## Default contents

```
<%= File.read!(Path.join(@layout_root, "_index.html")) %>
```

[^1]: These are subject to change before v1.0.0 launches
