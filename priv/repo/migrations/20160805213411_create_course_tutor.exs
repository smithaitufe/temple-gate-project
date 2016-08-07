defmodule PortalApi.Repo.Migrations.CreateCourseTutor do
  use Ecto.Migration

  def change do
    create table(:course_tutors) do
      add :course_id, references(:courses)
      add :staff_id, references(:staffs)
      add :academic_session_id, references(:academic_sessions)

      timestamps
    end
    create index(:course_tutors, [:course_id])
    create index(:course_tutors, [:staff_id])
    create index(:course_tutors, [:academic_session_id])

  end
end
