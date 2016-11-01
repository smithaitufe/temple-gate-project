defmodule PortalApi.Program do
  use PortalApi.Web, :model

  schema "programs" do
    field :name, :string
    field :description, :string
    field :details, :string
    field :duration, :integer


    has_many :levels, PortalApi.Level
    has_many :program_departments, PortalApi.ProgramDepartment
    has_many :departments, through: [:program_departments, :department]

    timestamps
  end

  @required_fields [:name, :description, :duration]
  @optional_fields [:details]

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
