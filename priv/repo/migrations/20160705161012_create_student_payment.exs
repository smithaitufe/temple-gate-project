defmodule PortalApi.Repo.Migrations.CreateStudentPayment do
  use Ecto.Migration

  def change do
    create table(:student_payments) do
      add :transaction_no, :string, limit: 20, null: false
      add :amount, :decimal
      add :service_charge, :decimal
      add :fee_id, references(:fees)
      add :payment_method_id, references(:terms)
      add :transaction_response_id, references(:transaction_responses)
      add :academic_session_id, references(:academic_sessions)
      add :student_id, references(:students)
      add :successful, :boolean, default: false


      timestamps
    end
    create index(:student_payments, [:student_id])
    create index(:student_payments, [:fee_id])
    create index(:student_payments, [:payment_method_id])
    create index(:student_payments, [:transaction_response_id])
    create index(:student_payments, [:academic_session_id])


  end
end
