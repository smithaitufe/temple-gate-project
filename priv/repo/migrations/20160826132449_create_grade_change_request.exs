defmodule PortalApi.Repo.Migrations.CreateGradeChangeRequest do
  use Ecto.Migration

  def change do
    create table(:grade_change_requests) do
      add :previous_score, :float
      add :previous_grade_letter, :string, limit: 5
      add :current_score, :float
      add :current_grade_letter, :string, limit: 5
      add :read, :boolean, default: false
      add :approved, :boolean, default: false
      add :closed, :boolean, default: false
      add :closed_at, :datetime
      add :rejected, :boolean, default: false
      # add :student_course_id, references(:student_courses)
      add :student_course_grading_id, references(:student_course_gradings)
      add :reason_id, references(:terms)
      add :previous_grade_id, references(:grades)
      add :current_grade_id, references(:grades)
      add :requested_by_staff_id, references(:staffs)
      add :closed_by_staff_id, references(:staffs)

      timestamps
    end
    create index(:grade_change_requests, [:student_course_grading_id])
    create index(:grade_change_requests, [:reason_id])
    create index(:grade_change_requests, [:previous_grade_id])
    create index(:grade_change_requests, [:current_grade_id])
    create index(:grade_change_requests, [:requested_by_staff_id])
    create index(:grade_change_requests, [:closed_by_staff_id])

  end
end
