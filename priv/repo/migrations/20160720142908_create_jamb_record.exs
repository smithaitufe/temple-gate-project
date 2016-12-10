defmodule PortalApi.Repo.Migrations.CreateJambRecord do
  use Ecto.Migration

  def change do
    create table(:jamb_records) do
      add :score, :float, null: false, default: 0.0
      add :registration_no, :string, limit: 20, null: false
      add :user_id, references(:users)
      add :year, :integer, null: false

      timestamps
    end
    create index(:jamb_records, [:user_id])
    create index(:jamb_records, [:year])

  end
end
