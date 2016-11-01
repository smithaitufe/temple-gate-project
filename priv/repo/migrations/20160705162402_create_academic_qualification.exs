defmodule PortalApi.Repo.Migrations.CreateAcademicQualification do
  use Ecto.Migration

  def change do
    create table(:academic_qualifications) do
      add :school, :string
      add :course_studied, :string
      add :from, :integer
      add :to, :integer
      add :user_id, references(:users)
      add :certificate_type_id, references(:terms)

      timestamps
    end
    create index(:academic_qualifications, [:user_id])
    create index(:academic_qualifications, [:certificate_type_id])

  end
end
