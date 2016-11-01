defmodule PortalApi.Repo.Migrations.CreateCourseEnrollmentAssessment do
  use Ecto.Migration

  def change do
    create table(:course_enrollment_assessments) do
      add :score, :float
      add :active, :boolean, default: true
      add :course_enrollment_id, references(:courses)
      add :assessed_by_user_id, references(:users)
      add :assessment_type_id, references(:terms)

      timestamps
    end
    create index(:course_enrollment_assessments, [:course_enrollment_id])
    create index(:course_enrollment_assessments, [:assessed_by_user_id])
    create index(:course_enrollment_assessments, [:assessment_type_id])

  end
end
