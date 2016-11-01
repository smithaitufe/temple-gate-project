defmodule PortalApi.UserProfile do
    use PortalApi.Web, :model

  schema "user_profiles" do      
      belongs_to :marital_status, PortalApi.Term, foreign_key: :marital_status_id
      belongs_to :gender, PortalApi.Term, foreign_key: :gender_id
      belongs_to :local_government_area, PortalApi.LocalGovernmentArea, foreign_key: :local_government_area_id
      field :birth_date, Ecto.Date
      field :phone_number, :string, limit: 15
      belongs_to :user, PortalApi.User, foreign_key: :user_id
      field :middle_name, :string, limit: 50 

      timestamps  
  end

  @required_fields [:gender_id, :marital_status_id, :birth_date, :local_government_area_id]
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