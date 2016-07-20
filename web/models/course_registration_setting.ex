defmodule PortalApi.CourseRegistrationSetting do
  use PortalApi.Web, :model

  schema "course_registration_settings" do
    field :opening_date, Ecto.Date
    field :closing_date, Ecto.Date
    belongs_to :program, PortalApi.Program
    belongs_to :academic_session, PortalApi.AcademicSession

    timestamps
  end

  @required_fields ~w(academic_session_id program_id opening_date closing_date)
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
