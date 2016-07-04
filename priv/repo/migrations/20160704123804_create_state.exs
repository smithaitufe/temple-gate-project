defmodule PortalApi.Repo.Migrations.CreateState do
  use Ecto.Migration

  def change do
    create table(:states) do
      add :name, :string, limit: 150, null: false
      add :country_id, references(:terms)

      timestamps
    end
    create index(:states, [:country_id])

  end
end
