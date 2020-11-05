defmodule Cronitex.MonitorServices.LiveUpdates do
  alias Phoenix

  def subscribe_live_view_for_monitor_id(monitor_id) do
    Phoenix.PubSub.subscribe(Cronitex.PubSub, monitor_id, link: true)
  end

  def notify_live_view_for_monitor_id(monitor_id, status) do
    Phoenix.PubSub.broadcast(Cronitex.PubSub, monitor_id, status)
  end
end
