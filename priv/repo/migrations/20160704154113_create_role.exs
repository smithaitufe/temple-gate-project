defmodule PortalApi.Repo.Migrations.CreateRole do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string, limit: 150, null: false
      add :description, :string
      add :slug, :string, null: false

      timestamps
    end

  end
end
