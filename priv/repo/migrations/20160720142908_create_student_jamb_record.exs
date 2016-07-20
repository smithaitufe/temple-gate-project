defmodule PortalApi.Repo.Migrations.CreateStudentJambRecord do
  use Ecto.Migration

  def change do
    create table(:student_jamb_records) do
      add :score, :float
      add :registration_no, :string
      add :student_id, references(:students)

      timestamps
    end
    create index(:student_jamb_records, [:student_id])

  end
end
