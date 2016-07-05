defmodule PortalApi.Repo.Migrations.CreateStudentResultGrade do
  use Ecto.Migration

  def change do
    create table(:student_result_grades) do
      add :score, :float      
      add :student_result_id, references(:student_results)
      add :course_id, references(:courses)
      add :grade_id, references(:grades)

      timestamps
    end
    create index(:student_result_grades, [:student_result_id])
    create index(:student_result_grades, [:course_id])
    create index(:student_result_grades, [:grade_id])

  end
end
