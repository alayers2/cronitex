# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :cronitex,
  ecto_repos: [Cronitex.Repo]

config :cronitex_web,
  ecto_repos: [Cronitex.Repo],
  generators: [context_app: :cronitex]

# Configures the endpoint
config :cronitex_web, CronitexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lUWFpNJuNJxuPmaZGTAyMpuTD4lcZ6T6W/kyhi1UTwblamrVK+NpYRHDKEWMyIl8",
  render_errors: [view: CronitexWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Cronitex.PubSub,
  live_view: [signing_salt: "PfGP58n6"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
