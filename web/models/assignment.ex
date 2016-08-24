defmodule PortalApi.Assignment do
  use PortalApi.Web, :model

  schema "assignments" do
    field :question, :string
    field :note, :string
    field :closing_date, Ecto.Date
    field :closing_time, Ecto.Time
    belongs_to :staff, PortalApi.Staff
    belongs_to :course, PortalApi.Course
    belongs_to :academic_session, PortalApi.AcademicSession

    timestamps
  end

  @required_fields ~w(question note closing_date closing_time staff_id course_id academic_session_id)
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
