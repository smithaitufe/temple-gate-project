defmodule PortalApi.Repo.Migrations.CreateStudentCourseGrading do
  use Ecto.Migration

  def change do
    create table(:student_course_gradings) do
      add :score, :float, null: false
      add :letter, :string, limit: 3, null: false
      add :weight, :float, null: false
      add :grade_point, :float, null: false
      add :student_course_id, references(:student_courses), null: false
      add :grade_id, references(:grades), null: false
      add :uploaded_by_staff_id, references(:staffs), null: false
      add :edited_by_staff_id, references(:staffs)

      timestamps
    end
    create index(:student_course_gradings, [:student_course_id])
    create index(:student_course_gradings, [:grade_id])
    create index(:student_course_gradings, [:uploaded_by_staff_id])
    create index(:student_course_gradings, [:edited_by_staff_id])

  end
end
