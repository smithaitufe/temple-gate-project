defmodule PortalApi.Job do
  use PortalApi.Web, :model

  schema "jobs" do
    field :title, :string
    field :description, :string
    field :qualifications, :string
    field :responsibilities, :string
    belongs_to :department_type, PortalApi.DepartmentType
    field :open, :boolean, default: false

    timestamps
  end

  @required_fields ~w(title description department_type_id)
  @optional_fields ~w(qualifications responsibilities open)

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
