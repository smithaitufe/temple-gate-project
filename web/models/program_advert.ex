defmodule PortalApi.ProgramAdvert do
  use PortalApi.Web, :model

  schema "program_adverts" do
    field :opening_date, Ecto.Date
    field :closing_date, Ecto.Date
    field :active, :boolean, default: false
    belongs_to :program, PortalApi.Program
    belongs_to :academic_session, PortalApi.AcademicSession

    timestamps
  end

  @required_fields ~w(program_id academic_session_id opening_date closing_date)a
  @optional_fields ~w(active)a

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
