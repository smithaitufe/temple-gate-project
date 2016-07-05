defmodule PortalApi.Repo.Migrations.CreateAssignment do
  use Ecto.Migration

  def change do
    create table(:assignments) do
      add :question, :text
      add :note, :text
      add :closing_date, :date
      add :closing_time, :time
      add :staff_id, references(:staffs)
      add :course_id, references(:courses)

      timestamps
    end
    create index(:assignments, [:staff_id])
    create index(:assignments, [:course_id])

  end
end
