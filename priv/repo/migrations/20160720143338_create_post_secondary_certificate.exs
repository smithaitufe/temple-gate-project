defmodule PortalApi.Repo.Migrations.CreatePostSecondaryCertificate do
  use Ecto.Migration

  def change do
    create table(:post_secondary_certificates) do
      add :school, :string, limit: 255, null: false
      add :course_studied, :string, limit: 255, null: false
      add :cgpa, :float, default: 0.0
      add :year_admitted, :integer, null: false
      add :year_graduated, :integer, null: false
      add :verified, :boolean, default: false
      add :verified_at, :datetime
      add :user_id, references(:users)
      add :verified_by_user_id, references(:users)

      timestamps
    end
    create index(:post_secondary_certificates, [:user_id])
    create index(:post_secondary_certificates, [:verified_by_user_id])

  end
end
