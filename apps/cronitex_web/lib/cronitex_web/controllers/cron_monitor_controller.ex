defmodule CronitexWeb.CronMonitorController do
  use CronitexWeb, :controller

  alias Cronitex.Monitors
  alias Cronitex.Monitors.CronMonitor

  def index(conn, _params) do
    cronmonitors = Monitors.list_user_monitors(conn.assigns.current_user)
    render(conn, "index.html", cronmonitors: cronmonitors)
  end

  def new(conn, _params) do
    changeset = Monitors.change_cron_monitor(%CronMonitor{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"cron_monitor" => cron_monitor_params}) do
    case Monitors.create_cron_monitor(conn.assigns.current_user, cron_monitor_params) do
      {:ok, cron_monitor} ->
        conn
        |> put_flash(:info, "Cron monitor created successfully.")
        |> redirect(to: Routes.cron_monitor_path(conn, :show, cron_monitor))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    cron_monitor = Monitors.get_user_monitor!(conn.assigns.current_user, id)
    render(conn, "show.html", cron_monitor: cron_monitor)
  end

  def edit(conn, %{"id" => id}) do
    cron_monitor = Monitors.get_user_monitor!(conn.assigns.current_user, id)
    changeset = Monitors.change_cron_monitor(cron_monitor)
    render(conn, "edit.html", cron_monitor: cron_monitor, changeset: changeset)
  end

  def update(conn, %{"id" => id, "cron_monitor" => cron_monitor_params}) do
    cron_monitor = Monitors.get_user_monitor!(conn.assigns.current_user, id)

    case Monitors.update_cron_monitor(cron_monitor, cron_monitor_params) do
      {:ok, cron_monitor} ->
        conn
        |> put_flash(:info, "Cron monitor updated successfully.")
        |> redirect(to: Routes.cron_monitor_path(conn, :show, cron_monitor))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", cron_monitor: cron_monitor, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    cron_monitor = Monitors.get_user_monitor!(conn.assigns.current_user, id)
    {:ok, _cron_monitor} = Monitors.delete_cron_monitor(cron_monitor)

    conn
    |> put_flash(:info, "Cron monitor deleted successfully.")
    |> redirect(to: Routes.cron_monitor_path(conn, :index))
  end
end
