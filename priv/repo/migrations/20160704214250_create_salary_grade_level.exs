defmodule PortalApi.Repo.Migrations.CreateSalaryGradeLevel do
  use Ecto.Migration

  def change do
    create table(:salary_grade_levels) do
      add :description, :string, limit: 3, null: false
      add :salary_structure_type_id, references(:terms)

      timestamps
    end
    create index(:salary_grade_levels, [:salary_structure_type_id])

  end
end
