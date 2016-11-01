defmodule PortalApi.Faculty do
  use PortalApi.Web, :model

  schema "faculties" do
    field :name, :string
    belongs_to :faculty_type, PortalApi.Term, foreign_key: :faculty_type_id
    has_many :departments, PortalApi.Department

    timestamps
  end

  @required_fields [:name, :faculty_type_id]
  @optional_fields []

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


  def load_associations(query \\ %PortalApi.Faculty{}) do
    from q in query,
    join: d in assoc(q, :departments),
    preload: [departments: d]
  end
end
