defmodule PortalApi.Repo.Migrations.CreateDepartment do
  use Ecto.Migration

  def change do
    create table(:departments) do
      add :name, :string
      add :code, :string
      add :faculty_id, references(:faculties)
      add :department_type_id, references(:terms)
      


      timestamps
    end
    create index(:departments, [:faculty_id])
    create index(:departments, [:department_type_id])

  end
end
