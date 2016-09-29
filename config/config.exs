# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :portal_api, PortalApi.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "RURvmZq12p9NiNDtHNps7N2I04xhTjE5YCFE0SrCUzPuJu0fRy2dLktNKdxp9kvI",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: PortalApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian to tailor JWT generation behaviour
config :guardian, Guardian,
  issuer: "PortalApi",
  ttl: { 3, :days },
  verify_issuer: true, # optional
  secret_key: "EDL8FGl7O6Xy-oIjdvcl4TRrx9EqKEkU_vKTi2qV3S95vfh1RB9gqiBJ6Uys-NuhSWCOn3FO84JFdpXy",
  serializer: PortalApi.GuardianSerializer

config :PortalApi, ecto_repos: [PortalApi.Repo]
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
