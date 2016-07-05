defmodule PortalApi.Repo.Migrations.CreateStudent do
  use Ecto.Migration

  def change do
    create table(:students) do
      add :first_name, :string, limit: 50, null: false
      add :last_name, :string, limit: 50, null: false
      add :middle_name, :string, limit: 50
      add :birth_date, :date
      add :phone_number, :string, limit: 15
      add :email, :string, limit: 200
      add :registration_no, :string, limit: 50
      add :matriculation_no, :string, limit: 50
      add :gender_id, references(:terms)
      add :marital_status_id, references(:terms)
      add :academic_session_id, references(:academic_sessions)
      add :department_id, references(:departments)
      add :program_id, references(:programs)
      add :level_id, references(:levels)

      timestamps
    end
    create index(:students, [:gender_id])
    create index(:students, [:marital_status_id])
    create index(:students, [:academic_session_id])
    create index(:students, [:department_id])
    create index(:students, [:program_id])
    create index(:students, [:level_id])

  end
end
