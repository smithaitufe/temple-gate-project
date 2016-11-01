defmodule PortalApi.JobPosting do
  use PortalApi.Web, :model

  schema "job_postings" do
    field :opening_date, Ecto.Date
    field :closing_date, Ecto.Date
    field :application_method, :string
    field :active, :boolean, default: true
    belongs_to :posted_by, PortalApi.User, foreign_key: :posted_by_user_id

    timestamps
  end

  @required_fields [:opening_date, :closing_date, :active, :application_method, :posted_by_user_id]
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
end
