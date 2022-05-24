---
tags:
  - interesting
---
# Document Tags

In [[zettelkasten]] tags are usually redundant. `wb` provides a simple
implementation that may serve as an additional grouping layer generating [[backlinks]].

Documents can be tagged via [[front matter]].

Before rendering is triggered, `wb` collects all the tagged documents, and writes unified tag index to disk in `tags/` directory under [[layout root]]. This directory contains a list of all tags and can be referenced via `<%= "[" <> "[tags]]" %>` [[wikilinks|wikilink]]. 

Default templates do not link the tag index out of the box.

> :eyes: This documentation is tagged for illustrative purposes. You can
access the tag index [[tags|here]]. This document has been tagged as [[#interesting]].

:warning: **The tags implementation comes with a couple of caveats:**

  - the user **must not** keep any static, custom content under the `tags` directory, otherwise they risk data loss when `wb` overwrites that specific subdirectory contents.
  - the user **should not** keep any document/directory explicitly titled/named `tags` in their [[layout root]], otherwise linking to automatically generated tag index may become impossible via [[wikilinks]]. In other words, if you decide to keep a `tags.md` file somewhere or a document annotated with `title: tags` front-matter meta, the `<%= "[" <> "[tags]]" %>` reference will probably resolve to your document and not to the `tags/` directory index.

So the rule of thumb is: **if you like to use document tags, do not create your own files/directories named `tags`**.

## Example

Assuming we have a sample set of documents tagged as follows:


`doc1.md`
---

```
---
title: Document one
tags:
 - happy
---
...(contents)
```

`doc2.md`
---

```
---
title: Document two
tags:
 - happy
 - fun
---
...(contents)
```

`wb` will create the following structure in :

```
tags
├── happy
│   └── index.md
└── fun
    └── index.md
```

Such that:
  - `happy/index.md` will contain links to `doc1.md` and `doc2.md`, 
  - `fun/index.md` will contain only one link to `doc2.md`.

Additionally, both `doc1.md` and `doc2.md` rendered will be annotated with
`#happy` and `#fun` backlinks.
