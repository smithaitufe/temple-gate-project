defmodule PortalApi.Repo.Migrations.CreateTransactionResponse do
  use Ecto.Migration

  def change do
    create table(:transaction_responses) do
      add :code, :string, limit: 5, null: false
      add :description, :string, null: false

      timestamps
    end

  end
end
