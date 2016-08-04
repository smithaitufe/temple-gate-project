defmodule PortalApi.JobPosting do
  use PortalApi.Web, :model

  schema "job_postings" do
    field :opening_date, Ecto.Date
    field :closing_date, Ecto.Date
    field :application_method, :string
    field :active, :boolean, default: false
    belongs_to :posted_by_user, PortalApi.PostedByUser

    timestamps
  end

  @required_fields ~w(opening_date closing_date active application_method posted_by_user_id)
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
end
