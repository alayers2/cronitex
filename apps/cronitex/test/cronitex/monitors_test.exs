defmodule Cronitex.MonitorsTest do
  use Cronitex.DataCase, async: true
  import Crontab.CronExpression
  alias Cronitex.Monitors

  describe "cronmonitors" do
    alias Cronitex.Monitors.CronMonitor

    @valid_attrs %{name: "valid cronmon", cron_expression: "* * * * * *"}
    @update_attrs %{name: "updated cronmon", cron_expression: "*/2 * * * * *", start_tolerance_seconds: 43}
    @invalid_attrs %{name: "invalid cronmon", cron_expression: nil, start_tolerance_seconds: nil, token: nil}

    def cron_monitor_fixture() do
      user = Cronitex.TestHelpers.user_fixture()
      {:ok, monitor} = Monitors.create_cron_monitor(user, @valid_attrs)
      [user: user, monitor: monitor]
    end

    test "list_cronmonitors/0 returns all cronmonitors" do
      cron_monitor_fixture()
      assert Enum.count(Monitors.list_cronmonitors()) == 1
    end

    test "list_user_monitors returns all cronmonitors for a user" do
      [user: user1, monitor: cron_monitor1] = cron_monitor_fixture()
      [user: _user2, monitor: _cron_monitor2] = cron_monitor_fixture()
      monitors = Monitors.list_user_monitors(user1)
      assert Enum.count(monitors) == 1
      [monitor | _tail] = monitors
      assert monitor.user_id == user1.id
      assert monitor.id == cron_monitor1.id
    end

    test "get_user_monitor returns a monitor by id for a user" do
      [user: user1, monitor: cron_monitor1] = cron_monitor_fixture()
      monitor = Monitors.get_user_monitor!(user1, cron_monitor1.id)
      assert monitor.id == cron_monitor1.id
    end

    test "get_user_monitor returns a monitor by id for a user raises" do
      [user: user1, monitor: _cron_monitor1] = cron_monitor_fixture()
      [user: _user2, monitor: cron_monitor2] = cron_monitor_fixture()
      catch_error Monitors.get_user_monitor!(user1, cron_monitor2.id)
    end

    test "get_cron_monitor!/1 returns the cron_monitor with given id" do
      [user: _user, monitor: cron_monitor] = cron_monitor_fixture()
      assert Monitors.get_cron_monitor!(cron_monitor.id).id == cron_monitor.id
    end

    test "create_cron_monitor/1 with valid data creates a cron_monitor" do
      user = Cronitex.TestHelpers.user_fixture()
      assert {:ok, %CronMonitor{} = cron_monitor} = Monitors.create_cron_monitor(user, @valid_attrs)
      assert cron_monitor.cron_expression == ~e[* * * * * *]
      assert cron_monitor.start_tolerance_seconds == 60
      # This will be a UUID, so assert is not nil
      assert cron_monitor.token
      assert cron_monitor.user_id == user.id
    end

    test "create_cron_monitor/1 with invalid data returns error changeset" do
      user = Cronitex.TestHelpers.user_fixture()
      assert {:error, %Ecto.Changeset{}} = Monitors.create_cron_monitor(user, @invalid_attrs)
    end

    test "update_cron_monitor/2 with valid data updates the cron_monitor" do
      [user: _user, monitor: cron_monitor] = cron_monitor_fixture()
      original_token = cron_monitor.token
      assert {:ok, %CronMonitor{} = cron_monitor} = Monitors.update_cron_monitor(cron_monitor, @update_attrs)
      assert cron_monitor.cron_expression == ~e[*/2 * * * * *]
      assert cron_monitor.start_tolerance_seconds == 43
      # assert token doesn't change
      assert cron_monitor.token == original_token
    end

    test "update_cron_monitor/2 with invalid data returns error changeset" do
      [user: _user, monitor: cron_monitor] = cron_monitor_fixture()
      assert {:error, %Ecto.Changeset{}} = Monitors.update_cron_monitor(cron_monitor, @invalid_attrs)
      # Validate not updated
      assert cron_monitor.cron_expression == Monitors.get_cron_monitor!(cron_monitor.id).cron_expression
    end

    test "delete_cron_monitor/1 deletes the cron_monitor" do
      [user: _user, monitor: cron_monitor] = cron_monitor_fixture()
      assert {:ok, %CronMonitor{}} = Monitors.delete_cron_monitor(cron_monitor)
      assert_raise Ecto.NoResultsError, fn -> Monitors.get_cron_monitor!(cron_monitor.id) end
    end

    test "change_cron_monitor/1 returns a cron_monitor changeset" do
      [user: _user, monitor: cron_monitor] = cron_monitor_fixture()
      assert %Ecto.Changeset{} = Monitors.change_cron_monitor(cron_monitor)
    end
  end
end
