defmodule PortalApi.Repo.Migrations.CreateJobPosting do
  use Ecto.Migration

  def change do
    create table(:job_postings) do
      add :opening_date, :date
      add :closing_date, :date
      add :application_method, :text
      add :active, :boolean, default: true
      add :posted_by_user_id, references(:users), null: false

      timestamps
    end
     
    create index(:job_postings, [:posted_by_user_id])

  end
end
