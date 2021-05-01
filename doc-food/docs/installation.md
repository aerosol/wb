# Installation

## Install via [hex](https://hex.pm/) package manager:

### Prerequisities:
  - [Elixir](https://elixir-lang.org/) 1.11 or greater


```
$ mix escript.install github aerosol/wb branch main
```

## Install with Docker

It is possible to run `wb` from a docker container if you don't like the idea
of installing the Elixir/OTP runtime on your own machine. This requires you to
mount your [[layout root]] and [[build root]] directories so that the container
can read and write them.

### Build docker image

```
$ git clone https://github.com/aerosol/wb.git main
$ cd wb && docker build -t wb .
```

### Run `wb` in a container

First, make sure your [[build root]] is created locally.

```
$ export WB_LOCAL_BUILD_ROOT=/tmp/my-wiki
$ mkdir $WB_LOCAL_BUILD_ROOT
```

Run `wb` from the container, mounting both [[layout root]] and [[build root]].
The third argument - domain, points at your local filesystem so the website is
available on your machine.

```
$ export WB_LOCAL_LAYOUT_ROOT=/path/to/your/local/markdown/dir

$ docker run --rm -it \
    --mount type=bind,source=${WB_LOCAL_LAYOUT_ROOT},target=/layout_root \
    wb new /layout_root

$ docker run --rm -it \
    --mount type=bind,source=${WB_LOCAL_LAYOUT_ROOT},target=/layout_root \
    --mount type=bind,source="/tmp/my-wiki/",target="/build_root/" \
    wb gen /layout_root /build_root ${WB_LOCAL_BUILD_ROOT}
```

## Create your first site

If all is well, at this point `wb` [escript](https://hexdocs.pm/mix/master/Mix.Tasks.Escript.Build.html) 
should be available for execution. You can now create your first site.

We'll create a new [[layout root]] in `my-wiki` directory.

```
$ wb new my-wiki
```

> :warning: You can run `wb new` on your existing markdown files directory. It won't
override anything, only copy the default [[templates]] to your [[layout root]] and
this is all you need to generate the site.

The next step is to drop your markdown docs into `my-wiki` directory and
generate the HTML site in some [[build root]], for example `/tmp/my-wiki-dev`:

```
$ wb gen my-wiki /tmp/my-wiki-dev
```

You can now visit `/tmp/my-wiki-dev/index.html` file in your browser to get
started.

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
