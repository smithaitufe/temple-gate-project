defmodule PortalApi.Repo.Migrations.CreateJobPosting do
  use Ecto.Migration

  def change do
    create table(:job_postings) do
      add :opening_date, :date
      add :closing_date, :date
      add :application_method, :text
      add :active, :boolean, default: false
      add :posted_by_user_id, references(:users)

      timestamps
    end
     
    create index(:job_postings, [:posted_by_user_id])

  end
end
