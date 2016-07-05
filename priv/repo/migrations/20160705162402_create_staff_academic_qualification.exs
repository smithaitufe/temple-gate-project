defmodule PortalApi.Repo.Migrations.CreateStaffAcademicQualification do
  use Ecto.Migration

  def change do
    create table(:staff_academic_qualifications) do
      add :school, :string
      add :course_studied, :string
      add :from, :integer
      add :to, :integer
      add :staff_id, references(:staffs)
      add :certificate_id, references(:terms)

      timestamps
    end
    create index(:staff_academic_qualifications, [:staff_id])
    create index(:staff_academic_qualifications, [:certificate_id])

  end
end
