defmodule PortalApi.Repo.Migrations.CreateGrade do
  use Ecto.Migration

  def change do
    create table(:grades) do
      add :minimum, :integer
      add :maximum, :integer
      add :point, :float
      add :description, :string

      timestamps
    end

  end
end
