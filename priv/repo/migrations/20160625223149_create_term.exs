defmodule PortalApi.Repo.Migrations.CreateTerm do
  use Ecto.Migration

  def change do
    create table(:terms) do
      add :description, :string, limit: 255, null: false
      add :term_set_id, references(:term_sets), null: false

      timestamps
    end
    create index(:terms, [:term_set_id])

  end
end
