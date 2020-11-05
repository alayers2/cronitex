defmodule Cronitex.Monitors.CronMonitor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cronmonitors" do
    field :name, :string
    field :cron_expression, Crontab.CronExpression.Ecto.Type
    field :start_tolerance_seconds, :integer, default: 60
    field :token, :string

    belongs_to :user, Cronitex.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(cron_monitor, attrs) do
    cron_monitor
    |> cast(attrs, [:name,:cron_expression, :start_tolerance_seconds])
    |> validate_required([:name, :cron_expression, :start_tolerance_seconds])
    |> unique_constraint(:token)
    |> unique_constraint([:name, :user_id])
    |> check_cron_expression()
    |> put_token()
  end

  defp check_cron_expression(changeset) do
    case Crontab.CronExpression.Parser.parse(changeset.data.cron_expression) do
      {:ok, _expression} -> changeset
      {:error, _error} -> add_error(changeset, :cron_expression, "Invalid Cron Expression.")
    end

  end

  defp put_token(changeset) do
    unless changeset.data.token do
      put_change(changeset, :token, Ecto.UUID.generate())
    else
      changeset
    end
  end
end
