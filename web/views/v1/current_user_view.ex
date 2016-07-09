defmodule PortalApi.V1.CurrentUserView do
  use PortalApi.Web, :view

  def render("show.json", %{user: user}) do
    %{data: %{
        id: user.id,
        user_name: user.user_name,
        email: user.email,
        user_category_id: user.user_category_id
      }
    }
  end

  def render("error.json", _) do
  end

end
