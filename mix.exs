defmodule Healthlocker.Mixfile do
  use Mix.Project

  def project do
    [app: :healthlocker,
     version: "1.0.0",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Healthlocker, []},
     applications: [
      :phoenix,
      :phoenix_pubsub,
      :phoenix_html,
      :cowboy,
      :logger,
      :gettext,
      :phoenix_ecto,
      :postgrex,
      :comeonin,
      :timex,
      :bamboo,
      :segment,
      :faker,
      :appsignal,
      :edeliver,
      :mssql_ecto,
      :mssqlex
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.1"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:earmark, "~> 1.1"},
     {:comeonin, "~> 3.0"},
     {:credo, "~> 0.7.2", only: [:dev, :test]},
     {:timex, "~> 3.0"},
     {:segment, github: "tonydaly/analytics-elixir"},
     {:bamboo, "~> 0.7"},
     {:bamboo_smtp, "~> 1.2.1"},
     {:mock, "~> 0.2.0", only: :test},
     {:faker, "~> 0.7"},
     {:appsignal, "~> 1.0"},
     {:wallaby, "~> 0.16.1"},
     {:ecto_factory, "~> 0.0.6"},
     {:edeliver, "~> 1.4.0"},
     {:distillery, ">= 0.8.0", warn_missing: false},
     {:mssql_ecto, "~> 0.1"},
     {:mssqlex, "~> 0.6"}
   ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
