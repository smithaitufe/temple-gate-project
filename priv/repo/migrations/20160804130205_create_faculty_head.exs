defmodule PortalApi.Repo.Migrations.CreateFacultyHead do
  use Ecto.Migration

  def change do
    create table(:faculty_heads) do
      add :active, :boolean, default: false
      add :appointment_date, :date
      add :effective_date, :date
      add :end_date, :string
      add :faculty_id, references(:faculties)
      add :assigned_user_id, references(:users)

      timestamps
    end
    create index(:faculty_heads, [:faculty_id])
    create index(:faculty_heads, [:assigned_user_id])

  end
end
