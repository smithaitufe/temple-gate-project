defmodule PortalApi.Repo.Migrations.CreateStaffLeaveEntitlement do
  use Ecto.Migration

  def change do
    create table(:staff_leave_entitlements) do
      add :entitled_leave, :integer, null: false
      add :remaining_leave, :integer, default: 0
      add :staff_id, references(:staffs)
      add :leave_track_type_id, references(:terms)

      timestamps
    end
    create index(:staff_leave_entitlements, [:staff_id])
    create index(:staff_leave_entitlements, [:leave_track_type_id])

  end
end
