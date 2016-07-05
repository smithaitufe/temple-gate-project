defmodule PortalApi.Repo.Migrations.CreateStudentPayment do
  use Ecto.Migration

  def change do
    create table(:student_payments) do
      add :student_id, references(:students)
      add :payment_id, references(:payments)
      add :academic_session_id, references(:academic_sessions)
      add :level_id, references(:levels)

      timestamps
    end
    create index(:student_payments, [:student_id])
    create index(:student_payments, [:payment_id])
    create index(:student_payments, [:academic_session_id])
    create index(:student_payments, [:level_id])

  end
end
