defmodule PortalApi.Repo.Migrations.CreatePosting do
  use Ecto.Migration

  def change do
    create table(:postings) do
      add :active, :boolean, default: true
      add :posted_user_id, references(:users)
      add :department_id, references(:departments)
      add :salary_grade_step_id, references(:salary_grade_steps)
      add :job_id, references(:jobs)
      add :effective_date, :date
      add :resumption_date, :date
      add :posted_date, :date

      timestamps
    end
    create index(:postings, [:posted_user_id])
    create index(:postings, [:department_id])
    create index(:postings, [:salary_grade_step_id])
    create index(:postings, [:job_id])

  end
end
