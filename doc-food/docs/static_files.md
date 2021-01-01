# Static Files

Static files, such as [[images]] are copied from [[layout root]] to [[build root]] verbatim.

A static file is anything that is:
  1. not a directory 
  2. not a markdown file (with `.md` extension)

For example, with the following structure inside your [[layout root]]:

```
images
└── gallery
    ├── 01.jpg
    ├── 02.jpg
    └── 03.jpg

```

The generated automatic [[index template]] URL (`/images/gallery/index.html`) will render
a list of links to those `jpg` files.
