defmodule PortalApi.Repo.Migrations.CreateStudentCourseAssessment do
  use Ecto.Migration

  def change do
    create table(:student_course_assessments) do
      add :score, :float
      add :active, :boolean, default: true
      add :student_course_id, references(:courses)
      add :staff_id, references(:staffs)
      add :assessment_type_id, references(:terms)

      timestamps
    end
    create index(:student_course_assessments, [:student_course_id])
    create index(:student_course_assessments, [:staff_id])
    create index(:student_course_assessments, [:assessment_type_id])

  end
end
