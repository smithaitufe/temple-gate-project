defmodule PortalApi.Repo.Migrations.CreateProgramDepartment do
  use Ecto.Migration

  def change do
    create table(:program_departments) do
      add :program_id, references(:programs)
      add :department_id, references(:departments)

      timestamps
    end
    create index(:program_departments, [:program_id])
    create index(:program_departments, [:department_id])

  end
end
