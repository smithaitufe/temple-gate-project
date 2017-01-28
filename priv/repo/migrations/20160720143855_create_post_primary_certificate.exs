defmodule PortalApi.Repo.Migrations.CreatePostPrimaryCertificate do
  use Ecto.Migration

  def change do
    create table(:post_primary_certificates) do
      add :year_obtained, :integer
      add :registration_no, :string
      add :user_id, references(:users)
      add :examination_type_id, references(:terms)

      timestamps()
    end
    create index(:post_primary_certificates, [:user_id])
    create index(:post_primary_certificates, [:examination_type_id])

  end
end
