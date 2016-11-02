defmodule PortalApi.Assignment do
  use PortalApi.Web, :model

  schema "assignments" do
    field :question, :string
    field :note, :string
    field :start_date, Ecto.Date
    field :start_time, Ecto.Time
    field :stop_date, Ecto.Date
    field :stop_time, Ecto.Time
    belongs_to :assigned_by, PortalApi.User, foreign_key: :assigned_by_user_id
    belongs_to :course, PortalApi.Course
    belongs_to :academic_session, PortalApi.AcademicSession

    timestamps
  end

  @required_fields [:question, :start_date, :start_time, :stop_date, :stop_time, :assigned_by_user_id, :course_id, :academic_session_id]
  @optional_fields [:note]

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
    [:course, :academic_session, :assigned_by]
  end


end
