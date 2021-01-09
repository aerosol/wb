# Wikilinks

## Resolution

In principle, `wb` does the best effort to find your document. Whether you are
a disciplined wiki author using proper `CamelCaseTitles` or just
throwing some docs around (and moving them endlessly), `wb` will try its best to always
resolve your documents.

> Tip: see also [[Backlinks]]

You can link `wb` documents using Wiki-like syntax:

```
[[link]]
```

or 

```
[[Link]]
```

This will resolve to either:

  1. `link.md` file, if present in current document's directory. In this case, the HTML link contents will resolve to [[title]].
  1. `link/index.html` if present, relative to current document's
     directory. In this case, the HTML link contents will resolve to
     directory name.
  1. any document, in any location, that is found first (no guarantees with
     regards to the order) whose basename matches `link`. For example if none
     of the above matches, but there is a `foo/bar/link.md` file somewhere it
     will match.
  1. using "liberal search" -- any document that is found first (no guarantees with regards to the order) whose title matches "link". The match is exact, but case insensetive, so a document with "LiNk" title will match, whereas a title "Some link" will not. In this case, the HTML link contents will resolve to [[title]].

### Overriding document titles

Optionally [[title|document titles]] can be overriden with special wikilinks syntax:

```
[[link|Alternative Title]]
```

