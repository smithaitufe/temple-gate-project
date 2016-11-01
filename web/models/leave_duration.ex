defmodule PortalApi.LeaveDuration do
  use PortalApi.Web, :model

  schema "leave_durations" do
    field :minimum_grade_level, :integer
    field :maximum_grade_level, :integer
    field :duration, :integer
    belongs_to :leave_track_type, PortalApi.Term, foreign_key: :leave_track_type_id

    timestamps
  end

  @required_fields ~w(minimum_grade_level maximum_grade_level duration leave_track_type_id)a
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
end
