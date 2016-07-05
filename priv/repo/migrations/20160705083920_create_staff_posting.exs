defmodule PortalApi.Repo.Migrations.CreateStaffPosting do
  use Ecto.Migration

  def change do
    create table(:staff_postings) do
      add :active, :boolean, default: true
      add :staff_id, references(:staffs)
      add :department_id, references(:departments)
      add :salary_grade_step_id, references(:salary_grade_steps)
      add :job_title_id, references(:job_titles)

      timestamps
    end
    create index(:staff_postings, [:staff_id])
    create index(:staff_postings, [:department_id])
    create index(:staff_postings, [:salary_grade_step_id])
    create index(:staff_postings, [:job_title_id])

  end
end
