defmodule PortalApi.Repo.Migrations.CreatePostPrimaryCertificateItem do
  use Ecto.Migration

  def change do
    create table(:post_primary_certificate_items) do
      add :post_primary_certificate_id, references(:post_primary_certificates)
      add :subject_id, references(:terms)
      add :grade_id, references(:terms)

      timestamps()
    end
    create index(:post_primary_certificate_items, [:post_primary_certificate_id])
    create index(:post_primary_certificate_items, [:subject_id])
    create index(:post_primary_certificate_items, [:grade_id])

  end
end
