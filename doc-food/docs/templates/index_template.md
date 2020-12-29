# Index template

Index template is stored in `_index.html` file.
It is the inner HTML, rendered within [[Main Template]] for automatically
indexed directories. The indexing happens only if a directory contains to
`index.md` file.

## Assings

Template assigns available are [^1]:

  - `@children` - a map with `docs` and `dirs` keys, each of which is a
    two-element tuple of `href` and directory `name` or document's `title`, respectively.
  - `@domain` - the target domain used for site generation. Can be used for
    building absolute links.
  - `@reldir` - relative directory of the index
  - `@relpath` - relative path of the index

## Default contents

```
<%= File.read!("doc-food/_index.html") %>
```

[^1]: These are subject to change before v1.0.0 launches
