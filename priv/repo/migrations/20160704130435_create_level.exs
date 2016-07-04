defmodule PortalApi.Repo.Migrations.CreateLevel do
  use Ecto.Migration

  def change do
    create table(:levels) do
      add :description, :string
      add :program_id, references(:programs)

      timestamps
    end
    create index(:levels, [:program_id])

  end
end
