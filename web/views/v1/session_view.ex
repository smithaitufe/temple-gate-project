defmodule PortalApi.V1.SessionView do
  use PortalApi.Web, :view
  alias PortalApi.V1.{UserRoleView, TermView, RoleView}
  def render("show.json", %{user: user, token: token}) do
    user = %{
    id: user.id,
    last_name: user.last_name,
    first_name: user.first_name,
    email: user.email    
    }
    |> Map.put(:roles, render_many(user.roles, RoleView, "role.json"))
    

    %{ user: user, token: token }

  end

  def render("error.json", _) do
    %{error: "Invalid login details"}
  end

  def render("delete.json", _) do
    %{ok: true}
  end

  def render("forbidden.json", %{error: error}) do
    %{error: error}
  end


  # defp render_roles(json, %{roles: roles}) do
  #   Map.put(json, :roles, render_many(roles, PortalApi.V1.TermView, "term.json"))
  # end
  # defp render_roles(json, _) do
  #   json
  # end

end
