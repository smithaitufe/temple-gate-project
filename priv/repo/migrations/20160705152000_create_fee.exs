defmodule PortalApi.Repo.Migrations.CreateFee do
  use Ecto.Migration

  def change do
    create table(:fees) do
      add :code, :string
      add :description, :string
      add :amount, :decimal
      add :is_catchment_area, :boolean, default: false
      add :program_id, references(:programs)
      add :level_id, references(:levels)
      add :service_charge_type_id, references(:terms)
      add :payer_category_id, references(:terms)

      timestamps
    end
    create index(:fees, [:program_id])
    create index(:fees, [:level_id])
    create index(:fees, [:service_charge_type_id])
    create index(:fees, [:payer_category_id])

  end
end
