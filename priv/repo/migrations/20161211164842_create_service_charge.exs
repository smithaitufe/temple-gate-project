defmodule PortalApi.Repo.Migrations.CreateServiceCharge do
  use Ecto.Migration

  def change do
    create table(:service_charges) do
      add :amount, :decimal, null: false, default: 0.0
      add :active, :boolean, default: false, null: false
      add :program_id, references(:programs, on_delete: :nothing)
      add :payer_category_id, references(:terms, on_delete: :nothing)

      timestamps()
    end
    create index(:service_charges, [:program_id])
    create index(:service_charges, [:payer_category_id])   

  end
end
