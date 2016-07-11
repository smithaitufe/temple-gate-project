defmodule PortalApi.Repo.Migrations.CreatePayment do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :transaction_no, :string, limit: 20, null: false
      add :amount, :decimal
      add :service_charge, :decimal
      add :fee_id, references(:fees)
      add :payment_status_id, references(:terms)
      add :payment_method_id, references(:terms)
      add :transaction_response_id, references(:transaction_responses)

      timestamps
    end
    create index(:payments, [:fee_id])
    create index(:payments, [:payment_status_id])
    create index(:payments, [:payment_method_id])
    create index(:payments, [:transaction_response_id])


  end
end
