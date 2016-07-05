defmodule PortalApi.Repo.Migrations.CreateSalaryGradeStep do
  use Ecto.Migration

  def change do
    create table(:salary_grade_steps) do
      add :description, :string
      add :salary_grade_level_id, references(:salary_grade_levels)

      timestamps
    end
    create index(:salary_grade_steps, [:salary_grade_level_id])

  end
end
