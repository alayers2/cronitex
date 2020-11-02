defmodule CronitexWeb.CronMonitorView do
  use CronitexWeb, :view
  alias Crontab.CronExpression.Composer

  def cron_str(%Crontab.CronExpression{} = cron_expression) do
    Composer.compose(cron_expression)
  end
end
