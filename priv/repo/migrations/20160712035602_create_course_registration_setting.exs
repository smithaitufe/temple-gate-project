defmodule PortalApi.Repo.Migrations.CreateCourseRegistrationSetting do
  use Ecto.Migration

  def change do
    create table(:course_registration_settings) do
      add :opening_date, :date
      add :closing_date, :date
      add :program_id, references(:programs)
      add :academic_session_id, references(:academic_sessions)

      timestamps
    end
    create index(:course_registration_settings, [:program_id])
    create index(:course_registration_settings, [:academic_session_id])

  end
end
