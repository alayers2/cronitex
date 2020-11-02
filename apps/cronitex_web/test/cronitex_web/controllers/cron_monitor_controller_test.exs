defmodule CronitexWeb.CronMonitorControllerTest do
  use CronitexWeb.ConnCase

  alias Cronitex.Monitors

  @create_attrs %{name: "cronmon", cron_expression: "some cron_expression", start_tolerance_seconds: 42, token: "some token"}
  @update_attrs %{name: "updated cronmon", cron_expression: "some updated cron_expression", start_tolerance_seconds: 43, token: "some updated token"}
  @invalid_attrs %{name: nil, cron_expression: nil, start_tolerance_seconds: nil, token: nil}

  def fixture(:cron_monitor) do
    {:ok, cron_monitor} = Monitors.create_cron_monitor(@create_attrs)
    cron_monitor
  end

  setup %{conn: conn} do
    user = Cronitex.TestHelpers.user_fixture()
    conn = assign(conn, :current_user, user)
    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all cronmonitors", %{conn: conn} do
      conn = get(conn, Routes.cron_monitor_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Cronmonitors"
    end
  end

  describe "new cron_monitor" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.cron_monitor_path(conn, :new))
      assert html_response(conn, 200) =~ "New Cron monitor"
    end
  end
end
