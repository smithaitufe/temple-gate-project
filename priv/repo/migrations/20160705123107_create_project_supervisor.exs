defmodule PortalApi.Repo.Migrations.CreateProjectSupervisor do
  use Ecto.Migration

  def change do
    create table(:project_supervisors) do
      add :tutor_user_id, references(:users)
      add :student_user_id, references(:users)
      add :project_status_id, references(:terms)

      timestamps
    end
    create index(:project_supervisors, [:tutor_user_id])
    create index(:project_supervisors, [:student_user_id])
    create index(:project_supervisors, [:project_status_id])

  end
end
