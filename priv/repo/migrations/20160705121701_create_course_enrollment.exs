defmodule PortalApi.Repo.Migrations.CreateCourseEnrollment do
  use Ecto.Migration

  def change do
    create table(:course_enrollments) do
      add :course_id, references(:courses)
      add :enrolled_by_user_id, references(:users)
      add :level_id, references(:levels)
      add :academic_session_id, references(:academic_sessions)
      add :graded, :boolean, default: false

      timestamps
    end
    create index(:course_enrollments, [:course_id])
    create index(:course_enrollments, [:enrolled_by_user_id])
    create index(:course_enrollments, [:level_id])
    create index(:course_enrollments, [:academic_session_id])

  end
end
