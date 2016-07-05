defmodule PortalApi.StudentResultGrade do
  use PortalApi.Web, :model

  schema "student_result_grades" do
    field :score, :float
    field :grade, :string
    belongs_to :student_result, PortalApi.StudentResult
    belongs_to :course, PortalApi.Course
    belongs_to :grade, PortalApi.Grade

    timestamps
  end

  @required_fields ~w(student_result_id course_id grade_id score grade)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
