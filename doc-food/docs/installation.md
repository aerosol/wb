# Installation

There are two methods of getting `wb` running on your machine.

## Install via Docker

```
$ git clone https://github.com/aerosol/wb.git
$ docker build -t wb .
$ alias wb='docker run wb'
```

## Install via [hex](https://hex.pm/) package manager:

### Prerequisities:
  - [Elixir](https://elixir-lang.org/) 1.11 or greater


```
$ mix escript.install github aerosol/wb branch main
```

## Create your first site

If all is well, at this point `wb` [escript](https://hexdocs.pm/mix/master/Mix.Tasks.Escript.Build.html) 
should be available for execution. You can now create your first site.

We'll create a new [[layout root]] in `my-wiki` directory.

```
$ wb new my-wiki
```

Great, the next step is to drop your markdown docs into `my-wiki` directory and
generate the HTML site in some [[build root]], for example `/tmp/my-wiki-dev`:

```
$ wb gen my-wiki /tmp/my-wiki-dev
```

You can now visit `/tmp/my-wiki-dev/index.html` file in your browser to get
started.

### Existing markdown database

You can run `wb new` on your existing markdown files directory. It won't
override anything, only copy the [[templates]] to your [[layout root]] and
this is all you need to generate the site.

### Develop

Because `wb` comes with no built-in development server by design, you can automate your
site generation using the standard unix tools, for example:

```
$ while true; do
wb gen my-wiki /tmp/my-wiki-dev && sleep 1
done
```

## Generate for the internets

If you wish to deploy your site, you need to provide `wb gen` with a third
argument - `domain` that will designate the deployment target URL. 
All the links `wb` generates will be prefixed with it.

```
$ wb gen my-wiki /tmp/my-wiki-prod https://example.com/my-wiki
```

That's it, enjoy.
