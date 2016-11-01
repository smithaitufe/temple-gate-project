defmodule PortalApi.Repo.Migrations.CreateOrder do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :selling_amount, :decimal
      add :buying_amount, :decimal
      add :is_invited, :boolean, default: false, null: false
      add :buyer, :boolean, default: false, null: false
      add :ordered_by_user_id, references(:users, on_delete: :nothing)
      add :product_id, references(:products, on_delete: :nothing)

      timestamps()
    end
    create index(:orders, [:ordered_by_user_id])
    create index(:orders, [:product_id])

  end
end
