defmodule PortalApi.Repo.Migrations.CreateCourseGrading do
  use Ecto.Migration

  def change do
    create table(:course_gradings) do
      add :score, :float, null: false
      add :letter, :string, limit: 3, null: false
      add :weight, :float, null: false
      add :grade_point, :float, null: false
      add :course_enrollment_id, references(:course_enrollments), null: false
      add :grade_id, references(:grades), null: false
      add :uploaded_by_user_id, references(:users), null: false
      add :modified_by_user_id, references(:users)

      timestamps
    end
    create index(:course_gradings, [:course_enrollment_id])
    create index(:course_gradings, [:grade_id])
    create index(:course_gradings, [:uploaded_by_user_id])
    create index(:course_gradings, [:modified_by_user_id])

  end
end
