# Static Files

Static files, such as [[images]] are copied from [[layout root]] to [[build root]] verbatim.

**NOTE** Unlike static [[directories]], files whose basename is prefixed with an
underscore (`_`) are _NOT_ copied over to the [[build root]].

A static file is anything that is:
  1. not a directory 
  2. not a markdown file (with `.md` extension)

For example, with the following structure inside your [[layout root]]:

```
images
└── gallery
    ├── 01.jpg
    ├── 02.jpg
    ├── _draft.png
    └── 03.jpg

```

The generated automatic [[index template]] URL (`/images/gallery/index.html`) will render
a list of links to those `jpg` files. It will _NOT_ contain `_draft.png` file,
because it's prefixed with an underscore.
