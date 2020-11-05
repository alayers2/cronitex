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
    |> start_cron_monitor_server()
  end

  def start_cron_monitor_server(cron_monitor_model) do
    cron_monitor_model
    |> Enum.into([], &cron_monitor_to_child_map/1)
    |> Supervisor.init(strategy: :one_for_one)
  end

  defp cron_monitor_to_child_map(model) do
    %{
      id: model.token,
      start: {CronMonitorServer, :start_link, [%{config: model}, []]}
    }
  end
end
