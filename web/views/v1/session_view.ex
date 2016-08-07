defmodule PortalApi.V1.SessionView do
  use PortalApi.Web, :view
  alias PortalApi.V1.{UserRoleView, TermView, RoleView}
  def render("show.json", %{user: user, token: token}) do
    user = %{
    id: user.id,
    user_name: user.user_name,
    email: user.email,
    user_category_id: user.user_category_id
    }
    |> Map.put(:roles, render_many(user.roles, RoleView, "role.json"))
    |> Map.put(:user_category, render_one(user.user_category, TermView, "term.json"))

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
