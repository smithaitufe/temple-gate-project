defmodule PortalApi.Faculty do
  use PortalApi.Web, :model

  schema "faculties" do
    field :name, :string
    belongs_to :faculty_type, PortalApi.Term
    has_many :departments, PortalApi.Department

    timestamps
  end

  @required_fields ~w(name faculty_type_id)
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


  def load_associations(query \\ %PortalApi.Faculty{}) do
    from q in query,
    join: d in assoc(q, :departments),
    preload: [departments: d]
  end
end
