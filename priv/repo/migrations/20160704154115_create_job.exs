defmodule PortalApi.Repo.Migrations.CreateJob do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :title, :string, null: false
      add :description, :text
      add :qualifications, :text
      add :responsibilities, :text
      add :department_type_id, references(:terms)
      add :open, :boolean, default: false

      timestamps
    end
    create index(:jobs, [:department_type_id])

  end
end
