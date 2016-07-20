defmodule PortalApi.Repo.Migrations.CreateStudentDiplomaQualification do
  use Ecto.Migration

  def change do
    create table(:student_diploma_qualifications) do
      add :school, :string
      add :course, :string
      add :cgpa, :float
      add :year_graduated, :integer
      add :student_id, references(:students)

      timestamps
    end
    create index(:student_diploma_qualifications, [:student_id])

  end
end
