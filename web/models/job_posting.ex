defmodule PortalApi.JobPosting do
  use Ecto.Schema
  import Ecto.Changeset


  schema "job_postings" do
    field :opening_date, Ecto.Date
    field :closing_date, Ecto.Date
    field :application_method, :string
    field :active, :boolean, default: false
    belongs_to :posted_by_user, PortalApi.PostedByUser

    timestamps
  end

  @required_fields ~w(opening_date closing_date active application_method posted_by_user_id)a
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
