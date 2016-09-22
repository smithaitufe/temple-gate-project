defmodule PortalApi.Repo.Migrations.CreateCourse do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :code, :string, limit: 10, null: false
      add :title, :string, null: false
      add :units, :integer
      add :hours, :integer
      add :core, :boolean, default: true
      add :description, :text
      add :department_id, references(:departments)
      add :level_id, references(:levels)
      add :semester_id, references(:terms)
      add :course_category_id, references(:terms)

      timestamps
    end
    create index(:courses, [:department_id])
    create index(:courses, [:level_id])
    create index(:courses, [:semester_id])

  end
end
