defmodule PortalApi.Repo.Migrations.CreateCourseEnrollment do
  use Ecto.Migration

  def change do
    create table(:course_enrollments) do
      add :course_id, references(:courses)
      add :student_id, references(:students)
      add :academic_session_id, references(:academic_sessions)

      timestamps
    end
    create index(:course_enrollments, [:course_id])
    create index(:course_enrollments, [:student_id])
    create index(:course_enrollments, [:academic_session_id])

  end
end
