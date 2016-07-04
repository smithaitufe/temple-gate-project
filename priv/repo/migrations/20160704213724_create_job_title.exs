defmodule PortalApi.Repo.Migrations.CreateJobTitle do
  use Ecto.Migration

  def change do
    create table(:job_titles) do
      add :description, :string
      add :department_type_id, references(:terms)

      timestamps
    end
    create index(:job_titles, [:department_type_id])

  end
end
