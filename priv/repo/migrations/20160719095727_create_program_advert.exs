defmodule PortalApi.Repo.Migrations.CreateProgramAdvert do
  use Ecto.Migration

  def change do
    create table(:program_adverts) do
      add :opening_date, :date
      add :closing_date, :date
      add :active, :boolean, default: false
      add :program_id, references(:programs)
      add :academic_session_id, references(:academic_sessions)

      timestamps
    end
    create index(:program_adverts, [:program_id])
    create index(:program_adverts, [:academic_session_id])

  end
end
