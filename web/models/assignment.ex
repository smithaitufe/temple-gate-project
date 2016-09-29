defmodule PortalApi.Assignment do
  use Ecto.Schema
  import Ecto.Changeset


  schema "assignments" do
    field :question, :string
    field :note, :string
    field :start_date, Ecto.Date
    field :start_time, Ecto.Time
    field :stop_date, Ecto.Date
    field :stop_time, Ecto.Time
    belongs_to :staff, PortalApi.Staff
    belongs_to :course, PortalApi.Course
    belongs_to :academic_session, PortalApi.AcademicSession

    timestamps
  end

  @required_fields ~w(question start_date start_time stop_date stop_time staff_id course_id academic_session_id)a
  @optional_fields ~w(note)a

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
    [:course, :academic_session, :staff]
  end


end
