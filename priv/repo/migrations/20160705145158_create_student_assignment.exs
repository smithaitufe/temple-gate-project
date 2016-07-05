defmodule PortalApi.Repo.Migrations.CreateStudentAssignment do
  use Ecto.Migration

  def change do
    create table(:student_assignments) do
      add :submission, :text
      add :student_id, references(:students)
      add :assignment_id, references(:assignments)

      timestamps
    end
    create index(:student_assignments, [:student_id])
    create index(:student_assignments, [:assignment_id])

  end
end
