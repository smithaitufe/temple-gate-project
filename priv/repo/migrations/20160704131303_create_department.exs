defmodule PortalApi.Repo.Migrations.CreateDepartment do
  use Ecto.Migration

  def change do
    create table(:departments) do
      add :name, :string
      add :code, :string
      add :faculty_id, references(:faculties)
      
      timestamps
    end
    create index(:departments, [:faculty_id])


  end
end
