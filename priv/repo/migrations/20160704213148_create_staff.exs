defmodule PortalApi.Repo.Migrations.CreateStaff do
  use Ecto.Migration

  def change do
    create table(:staffs) do
      add :registration_no, :string, limit: 30, null: false
      add :last_name, :string, limit: 50, null: false
      add :middle_name, :string, limit: 50
      add :first_name, :string, limit: 50, null: false
      add :birth_date, :date
      add :marital_status_id, references(:terms)
      add :gender_id, references(:terms)
      add :local_government_area_id, references(:local_government_areas)
      add :user_id, references(:users)
      

      timestamps
    end
    create index(:staffs, [:marital_status_id])
    create index(:staffs, [:gender_id])
    create index(:staffs, [:local_government_area_id])
    create index(:staffs, [:user_id])

  end
end
