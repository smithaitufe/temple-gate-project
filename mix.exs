defmodule PortalApi.Mixfile do
  use Mix.Project

  def project do
    [app: :portal_api,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     aliases: aliases
   ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {PortalApi, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :phoenix_ecto, :postgrex, :comeonin,:hackney, :ex_aws, :httpoison, :bamboo]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
     {:phoenix, "~> 1.2.1"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:cowboy, "~> 1.0"},
     {:corsica, "~> 0.4"},
     {:comeonin, "~> 2.1"},
     {:guardian, "~> 0.14.2"},
     {:timex, "~> 2.1.4"},
     {:timex_ecto, "~> 1.0.4"},
     {:arc, "~> 0.6.0"},
     {:phoenix_swagger, "~> 0.1.6"},
     {:hackney, "~> 1.6", override: true}, 
     {:ex_aws, "~> 1.0"},
     {:httpoison, "~> 0.11.0"},
     {:sweet_xml, "0.6.2"},
     {:bamboo, "~> 0.8.0"},
     {:bamboo_smtp, "~> 1.3"}
     
   ]
  end

  

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]
   ]
  end

  def swagger_info do
    [version: "0.0.0", title: "My awesome phoenix application"]
  end

end
