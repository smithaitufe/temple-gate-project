defmodule PortalApi.Repo.Migrations.CreateFee do
  use Ecto.Migration

  def change do
    create table(:fees) do
      add :code, :string
      add :description, :string
      add :amount, :decimal, precision: 8, scale: 2, default: 0.0, null: false
      add :service_charge, :decimal, precision: 8, scale: 2, default: 0.0, null: false
      add :program_id, references(:programs)
      add :level_id, references(:levels)
      add :payer_category_id, references(:terms)
      add :fee_category_id, references(:terms)
      add :area_type_id, references(:terms)

      timestamps
    end
    create index(:fees, [:program_id])
    create index(:fees, [:level_id])
    create index(:fees, [:fee_category_id])
    create index(:fees, [:payer_category_id])
    create index(:fees, [:area_type_id])
    create unique_index(:fees, [:code])

  end
end
