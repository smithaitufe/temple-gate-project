defmodule PortalApi.Repo.Migrations.CreateStudentPayment do
  use Ecto.Migration

  def change do
    create table(:student_payments) do
      add :student_id, references(:students)
      add :payment_id, references(:payments)
      
      timestamps
    end
    create index(:student_payments, [:student_id])
    create index(:student_payments, [:payment_id])


  end
end
