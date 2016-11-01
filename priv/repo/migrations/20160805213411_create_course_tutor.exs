defmodule PortalApi.Repo.Migrations.CreateCourseTutor do
  use Ecto.Migration

  def change do
    create table(:course_tutors) do
      add :course_id, references(:courses)
      add :tutor_user_id, references(:users)
      add :assigned_by_user_id, references(:users)
      add :academic_session_id, references(:academic_sessions)
      add :grades_submitted, :boolean, default: false
      add :grades_submitted_at, :datetime

      timestamps
    end
    create index(:course_tutors, [:course_id])
    create index(:course_tutors, [:tutor_user_id])
    create index(:course_tutors, [:assigned_by_user_id])
    create index(:course_tutors, [:academic_session_id])

  end
end
