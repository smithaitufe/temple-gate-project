defmodule PortalApi.StudentJambRecord do
  use Ecto.Schema
  import Ecto.Changeset

  schema "student_jamb_records" do
    field :score, :float
    field :registration_no, :string
    belongs_to :student, PortalApi.Student

    timestamps
  end

  @required_fields ~w(student_id score registration_no)a
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
