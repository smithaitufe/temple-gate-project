defmodule PortalApi.Repo.Migrations.CreateStudentProjectSupervisor do
  use Ecto.Migration

  def change do
    create table(:student_project_supervisors) do
      add :staff_id, references(:staffs)
      add :student_id, references(:students)
      add :project_status_id, references(:terms)

      timestamps
    end
    create index(:student_project_supervisors, [:staff_id])
    create index(:student_project_supervisors, [:student_id])
    create index(:student_project_supervisors, [:project_status_id])

  end
end
