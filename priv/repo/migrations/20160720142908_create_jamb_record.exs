defmodule PortalApi.Repo.Migrations.CreateJambRecord do
  use Ecto.Migration

  def change do
    create table(:jamb_records) do
      add :score, :float
      add :registration_no, :string
      add :user_id, references(:users)

      timestamps
    end
    create index(:jamb_records, [:user_id])

  end
end
