defmodule CronitexWeb.CronMonitorStatusLive do
  use Phoenix.LiveView
  alias Phoenix.PubSub

  def render(assigns) do
    ~L"""
    <%= @status %>
    """
  end

  def handle_info(message, socket) do
    {:noreply, assign(socket, :status, message)}
  end

  def mount(_params, %{"monitor_token" => monitor_token}, socket) do
    IO.puts("MOUNTING LIVE VIEW to topic #{monitor_token}")
    status = PubSub.subscribe(Cronitex.PubSub, monitor_token)
    IO.inspect(status)
    {:ok, assign(socket, :status, "Ready!")}
  end
end
