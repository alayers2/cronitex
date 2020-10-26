defmodule Cronitex.Repo do
  use Ecto.Repo,
    otp_app: :cronitex,
    adapter: Ecto.Adapters.Postgres
end
