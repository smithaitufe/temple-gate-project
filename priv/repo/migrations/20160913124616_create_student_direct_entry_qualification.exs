defmodule PortalApi.Repo.Migrations.CreateStudentDirectEntryQualification do
  use Ecto.Migration

  def change do
    create table(:student_direct_entry_qualifications) do
      add :school, :string, limit: 255, null: false
      add :course_studied, :string, limit: 255, null: false
      add :cgpa, :float, default: 0.0
      add :year_admitted, :integer, null: false
      add :year_graduated, :integer, null: false
      add :verified, :boolean, default: false
      add :verified_at, :datetime
      add :student_id, references(:students)
      add :verified_by_staff_id, references(:staffs)

      timestamps
    end
    create index(:student_direct_entry_qualifications, [:student_id])
    create index(:student_direct_entry_qualifications, [:verified_by_staff_id])

  end
end
