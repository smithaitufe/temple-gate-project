defmodule PortalApi.Repo.Migrations.CreateLeaveDuration do
  use Ecto.Migration

  def change do
    create table(:leave_durations) do
      add :minimum_grade_level, :integer, null: false
      add :maximum_grade_level, :integer, null: false
      add :duration, :integer, null: false
      add :leave_track_type_id, references(:terms)

      timestamps
    end
    create index(:leave_durations, [:leave_track_type_id])

  end
end
