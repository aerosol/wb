# Installation

## Install with Docker

Because Elixir does not allow us to build cross-platform binaries, docker
is the recommended way of installation for non-Elixir hackers.

### Build the image:

```
$ git clone --branch develop https://github.com/aerosol/wb.git
$ cd wb && docker build -t wb .
```

#### Make sure the wrapper script is available for execution

```
$ export PATH=$PATH:${PWD}/bin
```

or

```
$ alias wb=${PWD}/bin/wb
```

Next, head over to [[usage]].

## Install via [hex](https://hex.pm/) package manager

Alternatively you can install `wb` with `mix`.

### Prerequisities:

<details>
<summary>Elixir 1.11 or greater</summary>
<br/>
You can install <a href="https://elixir-lang.org">Elixir</a> with <a href="https://github.com/asdf-vm/asdf">asdf</a>:

<code>
$ git clone https://github.com/aerosol/wb.git develop && cd wb && asdf install
</code>
</details>

```
$ mix escript.install github aerosol/wb branch develop
```

