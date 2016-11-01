defmodule PortalApi.Repo.Migrations.CreateUserProfile do
  use Ecto.Migration

  def change do
    create table(:user_profiles) do     
      add :middle_name, :string, limit: 50
      add :birth_date, :date
      add :phone_number, :string, limit: 15      
      add :gender_id, references(:terms)
      add :marital_status_id, references(:terms)      
      add :local_government_area_id, references(:local_government_areas)           
      add :user_id, references(:users)
      timestamps
    end
    create index(:user_profiles, [:gender_id])
    create index(:user_profiles, [:marital_status_id])
    create index(:user_profiles, [:local_government_area_id])        
    create index(:user_profiles, [:user_id])

  end
end
