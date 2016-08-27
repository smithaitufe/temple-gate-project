defmodule PortalApi.LeaveDuration do
  use PortalApi.Web, :model

  schema "leave_durations" do
    field :minimum_grade_level, :integer
    field :maximum_grade_level, :integer
    field :duration, :integer
    belongs_to :leave_track_type, PortalApi.LeaveTrackType

    timestamps
  end

  @required_fields ~w(minimum_grade_level maximum_grade_level duration)
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
