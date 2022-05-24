# Single template

Single template is stored in `_single.html` file.
It is the inner HTML, rendered within [[Main Template]] containing your
markdown document(s) content.

## Assings

Template assigns available are [^1]:

  - `@domain` - the target domain used for site generation. Can be used for
    building absolute links.
  - `@reldir` - relative directory of the index
  - `@relpath` - relative path of the index
  - `@doc` - currently raw
    [`Document`](https://github.com/aerosol/wb/blob/main/lib/wb/resources/document.ex#L2) struct, providing access to, e.g. the [[front matter]] attributes
  - `@backlinks` - a list of two element tuples consisting of `href` and
    link `title`. See [[backlinks]] for more information.

## Default contents

```
<%= File.read!(Path.join(@layout_root, "_single.html")) %>
```

See also:
 - [[Index Template]]

## Footnotes

[^1]: These are subject to change before v1.0.0 launches
