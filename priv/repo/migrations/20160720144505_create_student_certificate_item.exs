defmodule PortalApi.Repo.Migrations.CreateStudentCertificateItem do
  use Ecto.Migration

  def change do
    create table(:student_certificate_items) do
      add :student_certificate_id, references(:student_certificates)
      add :subject_id, references(:terms)
      add :grade_id, references(:terms)

      timestamps
    end
    create index(:student_certificate_items, [:student_certificate_id])
    create index(:student_certificate_items, [:subject_id])
    create index(:student_certificate_items, [:grade_id])

  end
end
