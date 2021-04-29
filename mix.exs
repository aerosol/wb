defmodule Wb.MixProject do
  use Mix.Project

  def project do
    [
      app: :wb,
      version: "0.2.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :eex]
    ]
  end

  defp deps do
    [
      {:libgraph, "~> 0.13.3"},
      {:earmark, "~> 1.4"},
      {:exmoji, "~> 0.3.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:yaml_elixir, "~> 2.5"}
    ]
  end

  defp escript() do
    [main_module: WB.CLI, embed_elixir: true]
  end

  defp package() do
    [
      maintainers: ["Adam Rutkowski"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/aerosol/wb"},
      description: "Personal wiki engine"
    ]
  end
end
