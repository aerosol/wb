FROM hexpm/elixir:1.11.3-erlang-23.3.1-alpine-3.13.3

WORKDIR /

ENV MIX_ENV=dev
RUN mix do local.hex --force, local.rebar --force
COPY mix.exs mix.lock ./
COPY priv ./priv
COPY lib ./lib
COPY test ./test

RUN mix deps.get
RUN mix deps.compile
RUN mix escript.build
RUN chmod +x wb
ENTRYPOINT ["/wb"]
