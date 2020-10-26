defmodule Cronitex.Repo.Migrations.CreateCronmonitors do
  use Ecto.Migration

  def change do
    create table(:cronmonitors) do
      add :name, :string
      add :token, :string
      add :cron_expression, :string
      add :start_tolerance_seconds, :integer
      add :user_id, references(:users)
      timestamps()
    end

    # Token must be globally unique
    create unique_index(:cronmonitors, [:token])
    # Names must be unique to a user.
    create unique_index(:cronmonitors, [:user_id, :name])
  end
end
