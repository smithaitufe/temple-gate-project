defmodule PortalApi.Job do
  use PortalApi.Web, :model

  schema "jobs" do
    field :title, :string
    field :description, :string
    field :qualifications, :string
    field :responsibilities, :string    
    field :open, :boolean, default: false
    belongs_to :department_type, PortalApi.Term, foreign_key: :department_type_id

    timestamps
  end

  @required_fields [:title, :description, :department_type_id]
  @optional_fields [:qualifications, :responsibilities, :open]

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
