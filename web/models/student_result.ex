defmodule PortalApi.StudentResult do
  use PortalApi.Web, :model

  schema "student_results" do
    field :total_units, :integer
    field :total_score, :float
    field :total_point_average, :float
    field :number_passed, :integer
    field :number_failed, :integer
    field :promoted, :boolean, default: false
    belongs_to :academic_session, PortalApi.AcademicSession
    belongs_to :student, PortalApi.Student
    belongs_to :level, PortalApi.Level
    belongs_to :semester, PortalApi.Term

    timestamps
  end

  @required_fields ~w(academic_session_id student_id level_id semester_id total_units total_score total_point_average number_passed number_failed promoted)
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
