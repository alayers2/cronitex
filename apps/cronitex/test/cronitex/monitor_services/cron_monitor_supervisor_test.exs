defmodule Cronitex.MonitorServices.CronMonitorSupervisorTests do
  use Cronitex.DataCase

  alias Cronitex.MonitorServices.CronMonitorSupervisor
  alias Cronitex.TestHelpers
  alias Cronitex.Monitors

  test "supervisor spawns with correct children" do
      pid = Process.whereis(CronMonitorSupervisor)
      %{active: active} = Supervisor.count_children(pid)
      assert active == 0
  end

  test "supervisor respawns with corrct children" do
    user = TestHelpers.user_fixture()
    {:ok, monitor} = Monitors.create_cron_monitor(user, %{name: "valid cronmon", cron_expression: "* * * * * *"})

    pid = Process.whereis(CronMonitorSupervisor)
    ref = Process.monitor(pid)
    Process.exit(pid, :kill)
    receive do
      {:DOWN, ^ref, :process, ^pid, :killed} ->
        :timer.sleep 1

        # Now that we've created a monitor and restarted the process, we should expect that there's an active child of
        # our supervisor
        pid = Process.whereis(CronMonitorSupervisor)
        %{active: active} = Supervisor.count_children(pid)
        assert active == 1
    after
      1000 ->
        raise :timeout
    end

  end

end
