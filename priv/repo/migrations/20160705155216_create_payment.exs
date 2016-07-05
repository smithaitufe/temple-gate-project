defmodule PortalApi.Repo.Migrations.CreatePayment do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :transaction_no, :string, limit: 20, null: false
      add :sub_total, :decimal
      add :service_charge, :decimal
      add :payment_status_id, references(:terms)

      timestamps
    end
    create index(:payments, [:payment_status_id])

  end
end
