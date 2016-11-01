defmodule PortalApi.Repo.Migrations.CreateResult do
  use Ecto.Migration

  def change do
    create table(:results) do

      add :academic_session_id, references(:academic_sessions)
      add :student_user_id, references(:users)
      add :level_id, references(:levels)
      add :semester_id, references(:terms)
      add :course_id, references(:courses)
      add :grade_id, references(:grades)
      add :score, :float

      timestamps
    end
    create index(:results, [:academic_session_id])
    create index(:results, [:student_user_id])
    create index(:results, [:level_id])
    create index(:results, [:semester_id])
    create index(:results, [:course_id])
    create index(:results, [:grade_id])

  end
end
