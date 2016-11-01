defmodule PortalApi.Repo.Migrations.CreateAnnouncement do
  use Ecto.Migration

  def change do
    create table(:announcements) do
      add :heading, :text
      add :lead, :text
      add :body, :text      
      add :expires_at, :date
      add :active, :boolean, default: false      
      add :show_as_dialog, :boolean, default: false      

      timestamps
    end

  end
end
