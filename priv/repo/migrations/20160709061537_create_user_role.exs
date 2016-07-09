defmodule PortalApi.Repo.Migrations.CreateUserRole do
  use Ecto.Migration

  def change do
    create table(:user_roles) do
      add :default, :boolean, default: false
      add :user_id, references(:users)
      add :role_id, references(:terms)

      timestamps
    end
    create index(:user_roles, [:user_id])
    create index(:user_roles, [:role_id])

  end
end
