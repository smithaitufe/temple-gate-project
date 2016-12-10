defmodule PortalApi.Repo.Migrations.CreateProgramApplication do
  use Ecto.Migration

  def change do
    create table(:program_applications) do
      add :user_id, references(:users, on_delete: :nothing)
      add :registration_no, :string, limit: 50, null: false
      add :matriculation_no, :string, limit: 50, null: true      
      add :is_admitted, :boolean, default: false
      add :active, :boolean, default: true
      add :program_id, references(:programs, on_delete: :nothing)
      add :department_id, references(:departments, on_delete: :nothing)
      add :level_id, references(:levels, on_delete: :nothing)
      add :entry_mode_id, references(:terms, on_delete: :nothing)
      add :academic_session_id, references(:academic_sessions, on_delete: :nothing)

      timestamps()
    end
    create index(:program_applications, [:user_id])
    create index(:program_applications, [:program_id])
    create index(:program_applications, [:department_id])
    create index(:program_applications, [:level_id])
    create index(:program_applications, [:entry_mode_id])
    create index(:program_applications, [:academic_session_id])
    

  end
end
