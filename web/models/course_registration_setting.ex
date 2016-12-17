defmodule PortalApi.CourseRegistrationSetting do
  use PortalApi.Web, :model

  schema "course_registration_settings" do
    field :opening_date, Ecto.Date
    field :closing_date, Ecto.Date
    belongs_to :program, PortalApi.Program
    belongs_to :academic_session, PortalApi.AcademicSession

    timestamps
  end

  @required_fields ~w(academic_session_id program_id opening_date closing_date)a
  @optional_fields ~w()a

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, @required_fields ++ @optional_fields)
      |> validate_required(@required_fields)
  end


  def associations do
    [{:program, [:levels]}, :academic_session]
  end
end