# Usage

## Verify your installation:

```
$ wb

Writer's Block

Usage:

    wb [command]

Available commands:

    wb new [layout_root]
    wb gen [layout_root] [build_root] [target_domain]

Examples:

    wb new my-wiki
    wb gen my-wiki /tmp/my-wiki-dev # and navigate to file:///tmp/my-wiki-dev/index.html
    wb gen my-wiki /tmp/my-wiki-prod https://example.com
```

## Create your first site

You can now create your first site.

We'll create a new [[layout root]] in `my-wiki` directory.

```
$ wb new my-wiki
```

> :warning: You can run `wb new` on your existing markdown files directory. It won't
override anything, only copy the default [[templates]] to your [[layout root]] and
this is all you need to generate the site.

The next step is to drop your [[documents|markdown files]] into `my-wiki` directory and
generate the HTML site in some [[build root]], for example `/tmp/my-wiki-dev`:

```
$ wb gen my-wiki /tmp/my-wiki-dev
```

You can now visit `/tmp/my-wiki-dev/index.html` file in your browser to get
started.

### Develop

Because `wb` comes with no built-in development server by [[philosophy|design]], you can automate your
site generation using the standard unix tools, for example:

```
$ while true; do
wb gen my-wiki /tmp/my-wiki-dev && sleep 1
done
```

> :scream_cat: But I really want to run a web server locally!

Use one, use any. E.g. you can run `python -m http.server` in your [[build root]]. 
Just make sure the generated site refers to the fully qualified URL you're serving
it from, in this case `http://0.0.0.0:8000` (see the third argument desciption in the section below).

## Generate for the internets

If you wish to deploy your site, you need to provide `wb gen` with a third
argument - `domain` that will designate the deployment target URL. 
All the links `wb` generates will be prefixed with it.

```
$ wb gen my-wiki /tmp/my-wiki-prod https://example.com/my-wiki
```

It is up to you to choose your preferred method of deployment. For example, 
if you have a VPS with SSH access you can use rsync:

```
rsync -avz -e ssh /tmp/my-wiki my-vps:/home/weberver/my-wiki/
```

That's it, enjoy.
