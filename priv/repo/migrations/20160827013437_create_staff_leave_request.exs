defmodule PortalApi.Repo.Migrations.CreateStaffLeaveRequest do
  use Ecto.Migration

  def change do
    create table(:staff_leave_requests) do
      add :proposed_start_date, :date, null: false
      add :proposed_end_date, :date, null: false
      add :read, :boolean, default: false
      add :details, :string, limit: 255
      add :approved, :boolean, default: false
      add :approved_start_date, :date
      add :approved_end_date, :date
      add :no_of_days, :integer, default: 0
      add :closed, :boolean, default: false
      add :closed_at, :datetime
      add :staff_id, references(:staffs)
      add :closed_by_staff_id, references(:staffs)
      add :leave_type_id, references(:terms)


      timestamps
    end
    create index(:staff_leave_requests, [:staff_id])
    create index(:staff_leave_requests, [:closed_by_staff_id])
    create index(:staff_leave_requests, [:leave_type_id])



  end
end
