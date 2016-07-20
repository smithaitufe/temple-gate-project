defmodule PortalApi.StudentJambRecord do
  use PortalApi.Web, :model

  schema "student_jamb_records" do
    field :score, :float
    field :registration_no, :string
    belongs_to :student, PortalApi.Student

    timestamps
  end

  @required_fields ~w(score registration_no)
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
