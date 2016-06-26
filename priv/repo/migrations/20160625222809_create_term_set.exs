defmodule PortalApi.Repo.Migrations.CreateTermSet do
  use Ecto.Migration

  def change do
    create table(:term_sets) do
      add :name, :string
      add :display_name, :string

      timestamps
    end

  end
end
