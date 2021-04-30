# Templates

Default Writer's Block installation makes use of a tiny CSS sheet, a remix of [https://bestmotherfucking.website/](https://bestmotherfucking.website/)

`wb` comes with three templates out of the box:

  - [[Main Template]] - the outer HTML wrapping all your pages
  - [[Index Template]] - the inner HTML, rendered within [[Main Template]]
    that is used for automatic directory indexing
  - [[Single Template]] - the inner HTML, rendered within [[Main Template]]
    containing your markdown document(s) content

The only requirement is, all three must exist at least in your [[layout root]].

You are free to edit them, if you don't like the
default looks `wb` provides.

## Templates resolution

For each subdirectory containing your markdown documents you can override any of the templates from the top-level [[layout root]].

Say, your [[layout root]] is structured as follows:

```
my-wiki
├── thoughts
│   ├── index.md
│   ├── drafts
│   │   ├── index.md
│   │   ├── draft01.md
│   │   ├── draft02.md
│   │   └── draft03.md
│   └── ideas.md
├── index.md
├── _main.html
├── _index.html
└── _single.md
```

The templates that apply for all the pages are the ones in your root
directory. If, for whatever reason, you'd like to change how the documents in
`thoughts/drafts` render, you can maintain a copy of either `_main.html` or
`_single.html` (or both) in `thoughts/drafts`, like this:

```
my-wiki
├── thoughts
│   ├── index.md
│   ├── drafts
│   │   ├── index.md
│   │   ├── _single.html   <- here
│   │   ├── _main.html     <- here
│   │   ├── draft01.md
│   │   ├── draft02.md
│   │   └── draft03.md
│   └── ideas.md
├── index.md
├── _main.html
├── _index.html
└── _single.md
```

If you choose to only override `_single.html`, `_main.html` from the project
root will be used, and conversely, if you make a copy of only `_main.html`,
the parent `_single.html` will be used in `drafts`.

In the example above, `index.md` documents were created in all the directories, meaning `wb` will not
attempt to auto-index them. If you choose to remove `index.md` from any of
those directories, `wb` will create one, using the [[Index Template]].
