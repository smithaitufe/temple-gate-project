defmodule PortalApi.Repo.Migrations.CreateStudentResult do
  use Ecto.Migration

  def change do
    create table(:student_results) do

      add :academic_session_id, references(:academic_sessions)
      add :student_id, references(:students)
      add :level_id, references(:levels)
      add :semester_id, references(:terms)
      add :course_id, references(:courses)
      add :grade_id, references(:grades)
      add :score, :float

      timestamps
    end
    create index(:student_results, [:academic_session_id])
    create index(:student_results, [:student_id])
    create index(:student_results, [:level_id])
    create index(:student_results, [:semester_id])
    create index(:student_results, [:course_id])
    create index(:student_results, [:grade_id])

  end
end
