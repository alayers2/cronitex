defmodule Cronitex.MonitorServices.CronMonitorServer do
  use GenServer
  alias Phoenix.PubSub

  def start_link(init_arg, options) do
    GenServer.start_link(__MODULE__, init_arg, options)
  end

  @impl true
  def init(state) do
    # set the initial state
    state = Map.put(state, :monitor_state, :waiting_for_first_ping)
    PubSub.broadcast(Cronitex.PubSub, state.config.token, "waiting")
    # IO.inspect(state)

    state = schedule_work(state)
    # IO.inspect(state)
    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    state = schedule_work(state)
    state = Map.put(state, :monitor_state, :waiting)
    PubSub.broadcast(Cronitex.PubSub, state.config.token, "waiting")
    # IO.inspect(state)
    {:noreply, state}
  end

  @impl true
  def handle_info(:start_ping, state) do
    # If we get a success ping, disregard the timeout
    state = cancel_and_remove_timer(state, :timeout_timer)
    state = Map.put(state, :monitor_state, :ok)
    PubSub.broadcast(Cronitex.PubSub, state.config.token, "ok")
    # IO.inspect(state)
    {:noreply, state}
  end

  @impl true
  def handle_info(:timeout, state) do
    state = Map.put(state, :monitor_state, :start_timeout)
    PubSub.broadcast(Cronitex.PubSub, state.config.token, "start timeout")
    # IO.inspect(state)
    {:noreply, state}
  end

  @impl true
  def handle_info(:stop, state) do
    state = cancel_and_remove_timer(state, :work_timer)
    state = cancel_and_remove_timer(state, :timeout_timer)
    PubSub.broadcast(Cronitex.PubSub, state.config.token, "stopped")
    {:noreply, state}
  end

  defp cancel_and_remove_timer(state, timer_key) when is_map_key(state, timer_key) do
    Process.cancel_timer(state[timer_key])
    Map.pop(state, timer_key)
  end

  defp cancel_and_remove_timer(state, _timer_key), do: state


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
