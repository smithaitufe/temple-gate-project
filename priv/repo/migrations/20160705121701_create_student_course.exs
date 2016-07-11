defmodule PortalApi.Repo.Migrations.CreateCourseEnrollment do
  use Ecto.Migration

  def change do
    create table(:student_courses) do
      add :course_id, references(:courses)
      add :student_id, references(:students)
      add :academic_session_id, references(:academic_sessions)

      timestamps
    end
    create index(:student_courses, [:course_id])
    create index(:student_courses, [:student_id])
    create index(:student_courses, [:academic_session_id])

  end
end