defmodule PortalApi.Repo.Migrations.CreateStudentCertificateSubjectGrade do
  use Ecto.Migration

  def change do
    create table(:student_certificate_subject_grades) do
      add :student_certificate_id, references(:student_certificates)
      add :subject_id, references(:terms)
      add :grade_id, references(:terms)

      timestamps
    end
    create index(:student_certificate_subject_grades, [:student_certificate_id])
    create index(:student_certificate_subject_grades, [:subject_id])
    create index(:student_certificate_subject_grades, [:grade_id])

  end
end
