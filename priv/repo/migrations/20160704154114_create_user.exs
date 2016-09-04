defmodule PortalApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do

      add :user_name, :string, limit: 100, null: false
      add :email, :string
      add :encrypted_password, :string, null: false
      add :user_category_id, references(:terms)
      add :confirmed, :boolean, default: false
      add :confirmation_code, :string, limit: 20
      add :locked, :boolean, default: false
      add :suspended, :boolean, default: false

      timestamps
    end

  end
end
