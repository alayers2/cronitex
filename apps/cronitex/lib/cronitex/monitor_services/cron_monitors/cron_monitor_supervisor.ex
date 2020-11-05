defmodule Cronitex.MonitorServices.CronMonitorSupervisor do
  use Supervisor

  alias Cronitex.Monitors
  alias Cronitex.MonitorServices.CronMonitorServer

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    Monitors.list_cronmonitors()
    |> Enum.into([], fn (model) -> %{id: model.token, start: {CronMonitorServer, :start_link, [%{config: model}, []]}} end)
    |> Supervisor.init(strategy: :one_for_one)
  end
end
