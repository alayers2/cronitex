defmodule CronitexWeb.CronMonitorControllerTest do
  use CronitexWeb.ConnCase

  alias Cronitex.Monitors

  @create_attrs %{cron_expression: "some cron_expression", start_tolerance_seconds: 42, token: "some token"}
  @update_attrs %{cron_expression: "some updated cron_expression", start_tolerance_seconds: 43, token: "some updated token"}
  @invalid_attrs %{cron_expression: nil, start_tolerance_seconds: nil, token: nil}

  def fixture(:cron_monitor) do
    {:ok, cron_monitor} = Monitors.create_cron_monitor(@create_attrs)
    cron_monitor
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

  describe "create cron_monitor" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.cron_monitor_path(conn, :create), cron_monitor: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.cron_monitor_path(conn, :show, id)

      conn = get(conn, Routes.cron_monitor_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Cron monitor"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.cron_monitor_path(conn, :create), cron_monitor: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Cron monitor"
    end
  end

  describe "edit cron_monitor" do
    setup [:create_cron_monitor]

    test "renders form for editing chosen cron_monitor", %{conn: conn, cron_monitor: cron_monitor} do
      conn = get(conn, Routes.cron_monitor_path(conn, :edit, cron_monitor))
      assert html_response(conn, 200) =~ "Edit Cron monitor"
    end
  end

  describe "update cron_monitor" do
    setup [:create_cron_monitor]

    test "redirects when data is valid", %{conn: conn, cron_monitor: cron_monitor} do
      conn = put(conn, Routes.cron_monitor_path(conn, :update, cron_monitor), cron_monitor: @update_attrs)
      assert redirected_to(conn) == Routes.cron_monitor_path(conn, :show, cron_monitor)

      conn = get(conn, Routes.cron_monitor_path(conn, :show, cron_monitor))
      assert html_response(conn, 200) =~ "some updated cron_expression"
    end

    test "renders errors when data is invalid", %{conn: conn, cron_monitor: cron_monitor} do
      conn = put(conn, Routes.cron_monitor_path(conn, :update, cron_monitor), cron_monitor: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Cron monitor"
    end
  end

  describe "delete cron_monitor" do
    setup [:create_cron_monitor]

    test "deletes chosen cron_monitor", %{conn: conn, cron_monitor: cron_monitor} do
      conn = delete(conn, Routes.cron_monitor_path(conn, :delete, cron_monitor))
      assert redirected_to(conn) == Routes.cron_monitor_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.cron_monitor_path(conn, :show, cron_monitor))
      end
    end
  end

  defp create_cron_monitor(_) do
    cron_monitor = fixture(:cron_monitor)
    %{cron_monitor: cron_monitor}
  end
end
