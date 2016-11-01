defmodule PortalApi.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string, null: false
      add :description, :string, null: false
      add :long_description, :text
      add :price, :decimal
      add :quantity, :integer
      add :available_at, :date
      add :unavailable_at, :date
      add :is_negotiable, :boolean, default: false, null: false
      add :sold_by_user_id, references(:users, on_delete: :nothing)      
      add :is_sold, :boolean

      timestamps()
    end
    create index(:products, [:sold_by_user_id])
    create index(:products, [:name])

  end
end
