defmodule PortalApi.Repo.Migrations.CreateFaculty do
  use Ecto.Migration

  def change do
    create table(:faculties) do
      add :name, :string
      add :faculty_type_id, references(:terms)

      timestamps
    end
    create index(:faculties, [:faculty_type_id])

  end
end
