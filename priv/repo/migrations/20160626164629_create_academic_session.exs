defmodule PortalApi.Repo.Migrations.CreateAcademicSession do
  use Ecto.Migration

  def change do
    create table(:academic_sessions) do
      add :description, :string, limit: 10, null: false
      add :opening_date, :date
      add :closing_date, :date
      add :active, :boolean, default: true

      timestamps
    end

  end
end
