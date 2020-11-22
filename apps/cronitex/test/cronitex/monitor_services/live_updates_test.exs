defmodule Cronitex.MonitorServices.LiveUpdatesTest do
  use Cronitex.DataCase, async: true

  alias Cronitex.MonitorServices.LiveUpdates

  @monitor_id "1234-1234-1234-1234"

  test "nofify and subscribe for monitor token work correctly" do
    # Subscribe to notifications
    LiveUpdates.subscribe_live_view_for_monitor_id(@monitor_id)

    # Make sure we have no messages
    {:messages, messages} = Process.info(self(), :messages)
    assert Enum.count(messages) == 0

    # Notifiy on the same topic, and assert that we have one message with our payload
    LiveUpdates.notify_live_view_for_monitor_id(@monitor_id, :hello)
    {:messages, messages} = Process.info(self(), :messages)

    assert Enum.count(messages) == 1
    [message | _tail] = messages
    assert message == :hello
  end

end
