defmodule PortalApi.Repo.Migrations.CreateStudentCertificate do
  use Ecto.Migration

  def change do
    create table(:student_certificates) do
      add :year_obtained, :integer
      add :registration_no, :string
      add :student_id, references(:students)
      add :examination_body_id, references(:terms)

      timestamps
    end
    create index(:student_certificates, [:student_id])
    create index(:student_certificates, [:examination_body_id])

  end
end
