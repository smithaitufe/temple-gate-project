defmodule PortalApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :last_name, :string, limit: 50, null: false
      add :first_name, :string, limit: 50, null: false
      add :user_name, :string, limit: 100, null: false
      add :email, :string
      add :encrypted_password, :string, null: false

      timestamps
    end

  end
end
