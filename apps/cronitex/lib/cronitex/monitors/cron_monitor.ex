defmodule Cronitex.Monitors.CronMonitor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cronmonitors" do
    field :name, :string
    field :cron_expression, :string
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
    |> put_token()
  end

  defp put_token(changeset) do
    unless changeset.data.token do
      put_change(changeset, :token, Ecto.UUID.generate())
    else
      changeset
    end
  end
end
