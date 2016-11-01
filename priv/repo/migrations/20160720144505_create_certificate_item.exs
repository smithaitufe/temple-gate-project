defmodule PortalApi.Repo.Migrations.CreateCertificateItem do
  use Ecto.Migration

  def change do
    create table(:certificate_items) do
      add :certificate_id, references(:certificates)
      add :subject_id, references(:terms)
      add :grade_id, references(:terms)

      timestamps
    end
    create index(:certificate_items, [:certificate_id])
    create index(:certificate_items, [:subject_id])
    create index(:certificate_items, [:grade_id])

  end
end
