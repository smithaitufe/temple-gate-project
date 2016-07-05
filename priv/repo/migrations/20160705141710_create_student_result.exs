defmodule PortalApi.Repo.Migrations.CreateStudentResult do
  use Ecto.Migration

  def change do
    create table(:student_results) do
      add :total_units, :integer
      add :total_score, :float
      add :total_point_average, :float
      add :number_passed, :integer
      add :number_failed, :integer
      add :promoted, :boolean, default: false
      add :academic_session_id, references(:academic_sessions)
      add :student_id, references(:students)
      add :level_id, references(:levels)
      add :semester_id, references(:terms)

      timestamps
    end
    create index(:student_results, [:academic_session_id])
    create index(:student_results, [:student_id])
    create index(:student_results, [:level_id])
    create index(:student_results, [:semester_id])

  end
end
