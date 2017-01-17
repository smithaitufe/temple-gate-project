defmodule PortalApi.Repo.Migrations.CreateFacultyHead do
  use Ecto.Migration

  def change do
    create table(:faculty_heads) do
      add :active, :boolean, default: false
      add :appointment_date, :date
      add :effective_date, :date
      add :termination_date, :string
      add :faculty_id, references(:faculties)
      add :user_id, references(:users)

      timestamps
    end
    create index(:faculty_heads, [:faculty_id])
    create index(:faculty_heads, [:user_id])

  end
end
