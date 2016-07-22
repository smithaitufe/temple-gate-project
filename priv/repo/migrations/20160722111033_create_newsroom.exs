defmodule PortalApi.Repo.Migrations.CreateNewsroom do
  use Ecto.Migration

  def change do
    create table(:newsrooms) do
      add :lead, :text
      add :body, :text
      add :release_at, :date
      add :active, :boolean, default: false
      add :duration, :integer

      timestamps
    end

  end
end
