defmodule PortalApi.Repo.Migrations.CreateServiceChargeSplit do
  use Ecto.Migration

  def change do
    create table(:service_charge_splits) do
      add :amount, :decimal, default: 0.0
      add :name, :string, limit: 150, null: false
      add :bank_code, :string, limit: 10, null: false
      add :account, :string, limit: 25, null: false
      add :is_required, :boolean, default: false, null: false
      add :service_charge_id, references(:terms, on_delete: :nothing)

      timestamps()
    end
    create index(:service_charge_splits, [:service_charge_id])

  end
end
