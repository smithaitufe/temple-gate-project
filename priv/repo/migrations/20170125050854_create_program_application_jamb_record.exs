defmodule PortalApi.Repo.Migrations.CreateProgramApplicationJambRecord do
  use Ecto.Migration

  def change do
    create table(:program_application_jamb_records, primary_key: false) do
      add :jamb_record_id, references(:jamb_records, on_delete: :nothing)
      add :program_application_id, references(:program_applications, on_delete: :nothing)

      timestamps()
    end
    create index(:program_application_jamb_records, [:jamb_record_id])
    create index(:program_application_jamb_records, [:program_application_id])

  end
end
