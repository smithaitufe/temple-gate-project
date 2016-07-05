defmodule PortalApi.Repo.Migrations.CreateProjectTopic do
  use Ecto.Migration

  def change do
    create table(:project_topics) do
      add :title, :string
      add :approved, :boolean, default: false
      add :student_id, references(:students)

      timestamps
    end
    create index(:project_topics, [:student_id])

  end
end
