defmodule PortalApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, limit: 50, null: false
      add :last_name, :string, limit: 50, null: false      
      add :email, :string, limit: 200, null: false
      add :encrypted_password, :string, null: false      
      add :confirmed, :boolean, default: false
      add :confirmation_code, :string, limit: 20
      add :locked, :boolean, default: false
      add :suspended, :boolean, default: false
      
      timestamps
    end

    create index(:users, [:email])

  end
end
