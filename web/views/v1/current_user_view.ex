defmodule PortalApi.V1.CurrentUserView do
  use PortalApi.Web, :view
  alias PortalApi.V1.{UserRoleView, TermView, RoleView}
  def render("show.json", %{user: user}) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,            
      email: user.email     
    }
    |> Map.put(:roles, render_many(user.roles, RoleView, "role.json"))
    

  end

  def render("error.json", _) do
  end

end
