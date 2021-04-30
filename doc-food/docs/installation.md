# Installation

## Prerequisities:
  - [Elixir](https://elixir-lang.org/) 1.10 or greater

## Install via [hex](https://hex.pm/) package manager:

```
$ mix escript.install github aerosol/wb branch main
```

You're done. If all is well, `wb` [escript](https://hexdocs.pm/mix/master/Mix.Tasks.Escript.Build.html) should be avaiable in your `$PATH`.
You can now create your first site.

## Create your first site

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

Because `wb` comes with no built-in development server by design, you can automate your
site generation using the standard unix tools, for example:

```
$ while true; do
wb gen my-wiki /tmp/my-wiki-dev && sleep 1
done
```

## Generate for the internets

If you wish to deploy your site, you need to provide `wb gen` with a third
argument - `domain`, so all the links will be prefixed with it.

```
$ wb gen my-wiki /tmp/my-wiki-prod https://example.com/my-wiki
```

That's it, enjoy.
