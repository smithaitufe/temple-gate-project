defmodule PortalApi.V1.UserProfileView do
  use PortalApi.Web, :view
  alias PortalApi.V1.{UserPrfofileView, LocalGovernmentAreaView, StateView, TermView}

  def render("index.json", %{user_profiles: user_profiles}) do
    render_many(user_profiles, UserPrfofileView, "user_profile.json")
  end

  def render("show.json", %{user_profile: user_profile}) do
    render_one(user_profile, UserPrfofileView, "user_profile.json")
  end

  def render("user_profile.json", %{user_profile: user_profile}) do
      %{
      id: user_profile.id,      
      middle_name: user_profile.middle_name,
      birth_date: user_profile.birth_date,
      gender_id: user_profile.gender_id,
      marital_status_id: user_profile.marital_status_id,
      phone_number: user_profile.phone_number,
      user_id: user_profile.user_id
    }      
    |> Map.put(:marital_status, render_one(user_profile.marital_status, TermView, "term.json"))
    |> Map.put(:gender, render_one(user_profile.gender, TermView, "term.json"))
    |> Map.put(:local_government_area, render_one(user_profile.local_government_area, PortalApi.V1.LocalGovernmentAreaView, "local_government_area.json"))
    |> Map.put(:state_of_origin, render_one(user_profile.local_government_area.state, PortalApi.V1.StateView, "state.json"))
  end 

end
