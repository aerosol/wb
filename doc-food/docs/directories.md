# Directories

Directories in the [[layout root]] are automatically indexed if no `index.md`
file exists within.

Directories that are meant to be recursively copied verbatim and not indexed by
Writer's Block must start with an underscore character (`_`).

For example, with the following [[layout root]] structure:

```
example
├── stuff
│   ├── 01.md
│   ├── 02.md
│   └── bird.jpg
└── _vendor
    ├── css
    │   └── style.css
    └── js
        └── script.js
```

Files inside `example/stuff` will be automatically indexed (due to lack of the
[[index template]]), whilist `_vendor` directory with all its subdirectories
(`css` and `js`) will be copied verbatim over to [[build root]].
