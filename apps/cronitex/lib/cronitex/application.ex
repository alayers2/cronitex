defmodule Cronitex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Cronitex.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Cronitex.PubSub}
      # Start a worker by calling: Cronitex.Worker.start_link(arg)
      # {Cronitex.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Cronitex.Supervisor)
  end
end
