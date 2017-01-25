defmodule PortalApi.Repo.Migrations.CreateFee do
  use Ecto.Migration

  def change do
    create table(:fees) do
      add :code, :string
      add :description, :string
      add :amount, :decimal, precision: 8, scale: 2, default: 0.0, null: false
      add :program_id, references(:programs)
      add :service_charge_id, references(:terms, on_delete: :nothing)
      add :level_id, references(:levels, on_delete: :nothing)
      add :payer_category_id, references(:terms, on_delete: :nothing)
      add :fee_category_id, references(:terms, on_delete: :nothing)
      add :is_catchment, :boolean, default: false
      add :is_all, :boolean, default: false
      

      timestamps
    end
    create index(:fees, [:program_id])
    create index(:fees, [:level_id])
    create index(:fees, [:fee_category_id])
    create index(:fees, [:payer_category_id])    
    create unique_index(:fees, [:code])

  end
end
