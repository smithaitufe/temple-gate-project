defmodule PortalApi.Repo.Migrations.CreateDepartmentHead do
  use Ecto.Migration

  def change do
    create table(:department_heads) do
      add :active, :boolean, default: false
      add :appointment_date, :date
      add :effective_date, :date
      add :end_date, :string
      add :department_id, references(:departments)
      add :staff_id, references(:staffs)

      timestamps
    end
    create index(:department_heads, [:department_id])
    create index(:department_heads, [:staff_id])

  end
end
