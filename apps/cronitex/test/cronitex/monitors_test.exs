defmodule Cronitex.MonitorsTest do
  use Cronitex.DataCase

  alias Cronitex.Monitors

  describe "cronmonitors" do
    alias Cronitex.Monitors.CronMonitor

    @valid_attrs %{name: "valid cronmon", cron_expression: "some cron_expression"}
    @update_attrs %{name: "updated cronmon", cron_expression: "some updated cron_expression", start_tolerance_seconds: 43}
    @invalid_attrs %{name: "invalid cronmon", cron_expression: nil, start_tolerance_seconds: nil, token: nil}

    def cron_monitor_fixture(attrs \\ %{}) do
      {:ok, cron_monitor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Monitors.create_cron_monitor()

      cron_monitor
    end

    test "list_cronmonitors/0 returns all cronmonitors" do
      cron_monitor = cron_monitor_fixture()
      assert Monitors.list_cronmonitors() == [cron_monitor]
    end

    test "get_cron_monitor!/1 returns the cron_monitor with given id" do
      cron_monitor = cron_monitor_fixture()
      assert Monitors.get_cron_monitor!(cron_monitor.id) == cron_monitor
    end

    test "create_cron_monitor/1 with valid data creates a cron_monitor" do
      assert {:ok, %CronMonitor{} = cron_monitor} = Monitors.create_cron_monitor(@valid_attrs)
      assert cron_monitor.cron_expression == "some cron_expression"
      assert cron_monitor.start_tolerance_seconds == 60
      # This will be a UUID, so assert is not nil
      assert cron_monitor.token
    end

    test "create_cron_monitor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Monitors.create_cron_monitor(@invalid_attrs)
    end

    test "update_cron_monitor/2 with valid data updates the cron_monitor" do
      cron_monitor = cron_monitor_fixture()
      original_token = cron_monitor.token
      assert {:ok, %CronMonitor{} = cron_monitor} = Monitors.update_cron_monitor(cron_monitor, @update_attrs)
      assert cron_monitor.cron_expression == "some updated cron_expression"
      assert cron_monitor.start_tolerance_seconds == 43
      # assert token doesn't change
      assert cron_monitor.token == original_token
    end



    test "update_cron_monitor/2 with invalid data returns error changeset" do
      cron_monitor = cron_monitor_fixture()
      assert {:error, %Ecto.Changeset{}} = Monitors.update_cron_monitor(cron_monitor, @invalid_attrs)
      assert cron_monitor == Monitors.get_cron_monitor!(cron_monitor.id)
    end

    test "delete_cron_monitor/1 deletes the cron_monitor" do
      cron_monitor = cron_monitor_fixture()
      assert {:ok, %CronMonitor{}} = Monitors.delete_cron_monitor(cron_monitor)
      assert_raise Ecto.NoResultsError, fn -> Monitors.get_cron_monitor!(cron_monitor.id) end
    end

    test "change_cron_monitor/1 returns a cron_monitor changeset" do
      cron_monitor = cron_monitor_fixture()
      assert %Ecto.Changeset{} = Monitors.change_cron_monitor(cron_monitor)
    end
  end
end
