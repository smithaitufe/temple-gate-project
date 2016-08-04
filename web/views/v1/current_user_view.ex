defmodule PortalApi.V1.CurrentUserView do
  use PortalApi.Web, :view
  alias PortalApi.V1.{UserRoleView, TermView}
  def render("show.json", %{user: user}) do
    %{
    id: user.id,
    user_name: user.user_name,
    email: user.email,
    user_category_id: user.user_category_id
    }
    |> Map.put(:roles, render_many(user.roles, TermView, "term.json"))
    |> Map.put(:user_category, render_one(user.user_category, TermView, "term.json"))

  end

  def render("error.json", _) do
  end

end
