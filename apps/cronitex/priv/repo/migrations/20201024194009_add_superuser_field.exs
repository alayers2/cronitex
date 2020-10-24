defmodule Cronitex.Repo.Migrations.AddSuperuserField do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_superuser, :boolean
    end
  end
end
