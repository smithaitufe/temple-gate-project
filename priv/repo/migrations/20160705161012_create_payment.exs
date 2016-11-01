defmodule PortalApi.Repo.Migrations.CreatePayment do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :transaction_no, :string, limit: 20, null: false
      add :amount, :decimal
      add :service_charge, :decimal
      add :fee_id, references(:fees)
      add :payment_method_id, references(:terms)
      add :transaction_response_id, references(:transaction_responses)
      add :academic_session_id, references(:academic_sessions)
      add :paid_by_user_id, references(:users)
      add :successful, :boolean, default: false
      add :response_description, :string, limit: 150
      add :response_code, :string, limit: 5
      add :payment_reference_no, :string, limit: 50
      add :merchant_reference_no, :string, limit: 50


      timestamps
    end
    create index(:payments, [:paid_by_user_id])
    create index(:payments, [:fee_id])
    create index(:payments, [:payment_method_id])
    create index(:payments, [:transaction_response_id])
    create index(:payments, [:academic_session_id])


  end
end
