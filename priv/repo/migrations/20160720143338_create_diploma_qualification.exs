defmodule PortalApi.Repo.Migrations.CreateDiplomaQualification do
  use Ecto.Migration

  def change do
    create table(:diploma_qualifications) do
      add :school, :string
      add :course, :string
      add :cgpa, :float
      add :year_admitted, :integer, null: false
      add :year_graduated, :integer, null: false
      add :user_id, references(:users)

      timestamps
    end
    create index(:diploma_qualifications, [:user_id])

  end
end
