defmodule PriceTracker.Mixfile do
  use Mix.Project

  def project do
    [app: :price_tracker,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [
        :logger,
        :ecto,
        :postgrex,
        :ex_machina
      ],
     mod: {PriceTracker.Application, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ecto, "~> 2.0"},
      {:postgrex, "~> 0.11"},
      {:ex_machina, "~> 1.0", only: :test},
      {:mock, "~> 0.2.0", only: :test}
    ]
  end
end
