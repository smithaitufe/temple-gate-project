defmodule PortalApi.Repo.Migrations.CreateStudentProgram do
  use Ecto.Migration

  def change do
    create table(:student_programs) do
      add :student_id, references(:students)
      add :program_id, references(:programs)
      add :department_id, references(:departments)
      add :level_id, references(:levels)
      add :academic_session_id, references(:academic_sessions)

      timestamps
    end
    create index(:student_programs, [:student_id])
    create index(:student_programs, [:program_id])
    create index(:student_programs, [:department_id])
    create index(:student_programs, [:level_id])
    create index(:student_programs, [:academic_session_id])

  end
end
