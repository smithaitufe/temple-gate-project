defmodule PortalApi.ProgramApplicationPostSecondaryCertificate do
  use PortalApi.Web, :model

  @primary_key false
  schema "program_application_post_secondary_certificates" do
    belongs_to :program_application, PortalApi.ProgramApplication
    belongs_to :post_secondary_certificate, PortalApi.PostSecondaryCertificate

    timestamps()
  end

  @required_fields [:program_application_id, :post_secondary_certificate]
  @optional_fields []

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
