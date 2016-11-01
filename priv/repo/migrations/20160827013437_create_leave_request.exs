defmodule PortalApi.Repo.Migrations.CreateLeaveRequest do
  use Ecto.Migration

  def change do
    create table(:leave_requests) do
      add :proposed_start_date, :date, null: false
      add :proposed_end_date, :date, null: false
      add :read, :boolean, default: false
      add :details, :string, limit: 255
      add :approved, :boolean, default: false
      add :approved_start_date, :date
      add :approved_end_date, :date
      add :duration, :integer, default: 0
      add :closed, :boolean, default: false
      add :closed_at, :datetime      
      add :signed, :boolean, default: false
      add :accepted, :boolean, default: false
      add :deferred, :boolean, default: false
      add :requested_by_user_id, references(:users)
      add :closed_by_user_id, references(:users)
      add :signed_by_user_id, references(:users)
      add :leave_type_id, references(:terms)

      timestamps
    end
    create index(:leave_requests, [:requested_by_user_id])
    create index(:leave_requests, [:closed_by_user_id])
    create index(:leave_requests, [:signed_by_user_id])
    create index(:leave_requests, [:leave_type_id])



  end
end
