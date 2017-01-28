defmodule PortalApi.Repo.Migrations.CreateProgramApplicationPostSecondaryCertificate do
  use Ecto.Migration

  def change do
    create table(:program_application_post_secondary_certificates, primary_key: false) do
      add :program_application_id, references(:program_applications, on_delete: :nothing)
      add :post_secondary_certificate_id, references(:post_secondary_certificates, on_delete: :nothing)

      timestamps()
    end
    create index(:program_application_post_secondary_certificates, [:program_application_id])
    create index(:program_application_post_secondary_certificates, [:post_secondary_certificate_id])

  end
end
