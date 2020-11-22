defmodule Cronitex.MonitorServices.CronMonitorServer do
  use GenServer
  alias Cronitex.MonitorServices.LiveUpdates

  def start_link(init_arg, options) do
    GenServer.start_link(__MODULE__, init_arg, options)
  end

  @impl true
  def init(state) do
    state = update_monitor_state(state, :waiting)
    state = schedule_work(state)
    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    state = schedule_work(state)
    state = update_monitor_state(state, :waiting)
    {:noreply, state}
  end

  @impl true
  def handle_info(:start_ping, state) do
    # If we get a success ping, disregard the timeout
    state = cancel_and_remove_timer(state, :timeout_timer)
    state = update_monitor_state(state, :ok)
    {:noreply, state}
  end

  @impl true
  def handle_info(:timeout, state) do
    state = update_monitor_state(state, :start_timeout)
    {:noreply, state}
  end

  @impl true
  def handle_info(:stop, state) do
    state = cancel_and_remove_timer(state, :work_timer)
    state = cancel_and_remove_timer(state, :timeout_timer)
    state = update_monitor_state(state, :stopped)
    {:noreply, state}
  end

  defp cancel_and_remove_timer(state, timer_key) when is_map_key(state, timer_key) do
    Process.cancel_timer(state[timer_key])
    Map.pop(state, timer_key)
  end

  defp cancel_and_remove_timer(state, _timer_key), do: state

  defp update_monitor_state(state, monitor_state) do
    state = Map.put(state, :monitor_state, monitor_state)
    LiveUpdates.notify_live_view_for_monitor_id(state.config.token, monitor_state)
    state
  end


  defp schedule_work(state) do
    # Whenever we schedule work, we need to set two timers, one that executes with the crontab, and one that executes with the timeout
    {:ok, next_rundate} = Crontab.Scheduler.get_next_run_date(state.config.cron_expression)
    milliseconds_till_run = NaiveDateTime.diff(next_rundate, DateTime.to_naive(DateTime.utc_now()), :millisecond)
    timer = Process.send_after(self(), :work, milliseconds_till_run)
    state = Map.put(state, :work_timer, timer)

    timeout_milliseconds = state.config.start_tolerance_seconds * 1000
    timeout_timer = Process.send_after(self(), :timeout, milliseconds_till_run + timeout_milliseconds)
    state = Map.put(state, :timeout_timer, timeout_timer)
    state
  end

end
