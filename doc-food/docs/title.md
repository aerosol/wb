# Document Titles

Document titles are resolved via whatever is found first, in this particular order:

1. Through explit [[Wikilinks]] titles using the `|` syntax
1. [[FrontMatter]] `title` attribute
1. First level-one header, e.g.:
  ```
  # This is my document
  ```
1. Fallback to markdown file basename

## Example

For example, this document's title is... uhm "Document Titles" :sweat_smile:, because of its
top-level heading. Its source markdown file was lazily named `title.md`. Thus, if we link to it using the [[Wikilinks]] syntax, by
writing:

```
<%= "[" <> "[title]]" %>
```


in markdown, it will resolve literally to: 

```
[[title]]
```
