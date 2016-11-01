defmodule PortalApi.Repo.Migrations.CreateProgram do
  use Ecto.Migration

  def change do
    create table(:programs) do
      add :name, :string, limit: 100, null: false
      add :description, :string, limit: 256, null: false
      add :details, :string
      add :duration, :integer, null: false, default: 2

      timestamps
    end

  end
end
