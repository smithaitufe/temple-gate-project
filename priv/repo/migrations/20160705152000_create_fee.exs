defmodule PortalApi.Repo.Migrations.CreateFee do
  use Ecto.Migration

  def change do
    create table(:fees) do
      add :code, :string
      add :description, :string
      add :amount, :decimal
      add :service_charge, :decimal, default: 0
      add :is_catchment_area, :boolean, default: false
      add :program_id, references(:programs)
      add :level_id, references(:levels)
      add :fee_category_id, references(:terms)

      timestamps
    end
    create index(:fees, [:program_id])
    create index(:fees, [:level_id])
    create index(:fees, [:fee_category_id])
    create unique_index(:fees, [:code])

  end
end
