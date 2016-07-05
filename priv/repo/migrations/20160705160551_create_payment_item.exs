defmodule PortalApi.Repo.Migrations.CreatePaymentItem do
  use Ecto.Migration

  def change do
    create table(:payment_items) do
      add :amount, :decimal
      add :payment_id, references(:payments)
      add :fee_id, references(:fees)

      timestamps
    end
    create index(:payment_items, [:payment_id])
    create index(:payment_items, [:fee_id])

  end
end
