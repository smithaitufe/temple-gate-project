defmodule PortalApi.Repo.Migrations.CreateProjectTopic do
  use Ecto.Migration

  def change do
    create table(:project_topics) do
      add :title, :string
      add :approved, :boolean, default: false
      add :submitted_by_user_id, references(:users)

      timestamps
    end
    create index(:project_topics, [:submitted_by_user_id])

  end
end
