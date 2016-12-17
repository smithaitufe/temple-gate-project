defmodule PortalApi.Repo.Migrations.CreateAssignment do
  use Ecto.Migration

  def change do
    create table(:assignments) do
      add :question, :text
      add :note, :text
      add :start_date, :date
      add :start_time, :time 
      add :stop_date, :date
      add :stop_time, :time
      add :assigned_by_user_id, references(:users)
      add :course_id, references(:courses)
      add :academic_session_id, references(:academic_sessions)

      timestamps
    end
    create index(:assignments, [:assigned_by_user_id])
    create index(:assignments, [:course_id])
    create index(:assignments, [:academic_session_id])

  end
end