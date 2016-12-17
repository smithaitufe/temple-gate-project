defmodule PortalApi.Repo.Migrations.CreateGrade do
  use Ecto.Migration

  def change do
    create table(:grades) do
      add :maximum, :integer, null: false
      add :minimum, :integer, null: false
      add :point, :float, null: false
      add :description, :string, limit: 3, null: false

      timestamps
    end

  end
end