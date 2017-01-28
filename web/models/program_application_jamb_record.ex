defmodule PortalApi.ProgramApplicationJambRecord do
  use PortalApi.Web, :model
  @primary_key false
  schema "program_application_jamb_records" do
    belongs_to :jamb_record, PortalApi.JambRecord
    belongs_to :program_application, PortalApi.ProgramApplication

    timestamps()
  end

  @required_fields [:program_application_id, :jamb_record_id]
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
