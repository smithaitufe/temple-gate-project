defmodule PortalApi.Repo.Migrations.CreatePayment do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :transaction_reference_no, :string, limit: 20, null: false
      add :amount, :decimal
      add :service_charge, :decimal      
      add :academic_session_id, references(:academic_sessions)
      add :user_id, references(:users)
      add :fee_id, references(:fees)
      add :online, :boolean, default: false
      add :successful, :boolean, default: false
      add :response_description, :string, limit: 150
      add :response_code, :string, limit: 5
      add :payment_reference_no, :string, limit: 50
      add :merchant_reference_no, :string, limit: 50      
      add :receipt_no, :string, limit: 20
      add :payment_date, :string, limit: 30
      add :settlement_date, :string, limit: 30
      add :site_redirect_url, :string

      timestamps
    end
    create index(:payments, [:user_id])
    create index(:payments, [:fee_id])
    create index(:payments, [:successful])
    create index(:payments, [:response_code])
    create index(:payments, [:response_description])
    create index(:payments, [:academic_session_id])


  end
end
