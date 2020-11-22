defmodule CronitexWeb.CronMonitorStatusLive do
  use Phoenix.LiveView
  alias Cronitex.MonitorServices.LiveUpdates


  def render(assigns) do
    ~L"""
    <%= @status %>
    """
  end

  def handle_info(message, socket) do
    {:noreply, assign(socket, :status, message)}
  end

  def mount(_params, %{"monitor_token" => monitor_token}, socket) do
    LiveUpdates.subscribe_live_view_for_monitor_id(monitor_token)
    
    {:ok, assign(socket, :status, "Ready!")}
  end
end
