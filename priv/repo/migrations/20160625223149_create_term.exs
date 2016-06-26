defmodule PortalApi.Repo.Migrations.CreateTerm do
  use Ecto.Migration

  def change do
    create table(:terms) do
      add :description, :string
      add :term_set_id, references(:term_sets)

      timestamps
    end
    create index(:terms, [:term_set_id])

  end
end
