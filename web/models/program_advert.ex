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

  @required_fields ~w(program_id academic_session_id opening_date closing_date)
  @optional_fields ~w(active)

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
