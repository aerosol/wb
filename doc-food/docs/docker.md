## Install with Docker

> :warning: Make sure to visit [[usage]] section first, to understand the
> basics before proceeding with docker installation.

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
$ mkdir ${WB_LOCAL_BUILD_ROOT}
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
    --mount type=bind,source=${WB_LOCAL_BUILD_ROOT}",target="/build_root/" \
    wb gen /layout_root /build_root ${WB_LOCAL_BUILD_ROOT}
```

If all is well, you should be able to open your website at
`file://${WB_LOCAL_BUILD_ROOT}`.

