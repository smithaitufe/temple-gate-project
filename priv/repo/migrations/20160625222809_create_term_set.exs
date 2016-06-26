defmodule PortalApi.Repo.Migrations.CreateTermSet do
  use Ecto.Migration

  def change do
    create table(:term_sets) do
      add :name, :string, limit: 255, null: false
      add :display_name, :string, limit: 255, null: false

      timestamps
    end

  end
end
