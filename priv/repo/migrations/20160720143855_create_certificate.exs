defmodule PortalApi.Repo.Migrations.CreateCertificate do
  use Ecto.Migration

  def change do
    create table(:certificates) do
      add :year_obtained, :integer
      add :registration_no, :string
      add :user_id, references(:users)
      add :examination_body_id, references(:terms)

      timestamps
    end
    create index(:certificates, [:user_id])
    create index(:certificates, [:examination_body_id])

  end
end
