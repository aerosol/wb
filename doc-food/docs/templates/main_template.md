# Main template

Main template is stored in `_main.html` file.
It is the outer HTML wrapping all your pages for both [[Index Template]] and
[[Single Template]].

Standard [EEx](https://hexdocs.pm/eex/EEx.html) applies if needed.

## Assings

Template assigns available are [^1]:

  - `@domain` - the target domain used for site generation. Can be used for
    building absolute links.
  - `@reldir` - relative directory of the index
  - `@relpath` - relative path of the index
  - any assigns passed to [[Index Template]] or [[Single Template]], depending
    on which is being rendered

## Default contents

```
<%= File.read!("doc-food/_main.html") %>
```
