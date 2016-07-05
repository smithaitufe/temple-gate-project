defmodule PortalApi.Repo.Migrations.CreateStudentContinuousAssessment do
  use Ecto.Migration

  def change do
    create table(:student_continuous_assessments) do
      add :score, :float
      add :course_id, references(:courses)
      add :staff_id, references(:staffs)
      add :student_id, references(:students)
      add :continuous_assessment_type_id, references(:terms)

      timestamps
    end
    create index(:student_continuous_assessments, [:course_id])
    create index(:student_continuous_assessments, [:staff_id])
    create index(:student_continuous_assessments, [:student_id])
    create index(:student_continuous_assessments, [:continuous_assessment_type_id])

  end
end
