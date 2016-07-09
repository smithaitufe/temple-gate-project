defmodule PortalApi.V1.SessionView do
  use PortalApi.Web, :view
  def render("show.json", %{jwt: jwt, user: user, roles: roles}) do

    user = %{
      id: user.id,
      user_name: user.user_name,
      email: user.email,
      user_category_id: user.user_category_id
    }
    |> render_user_category(user_category: user.user_category)
    |> render_roles(%{roles: roles})

    %{data:
      %{
        user: user,
        jwt: jwt
      }
    }
  end
  def render("show.json", %{jwt: jwt, user: user}) do

    user = %{
      id: user.id,
      user_name: user.user_name,
      email: user.email,
      user_category_id: user.user_category_id
    }
    |> render_user_category(%{user_category: user.user_category})
    |> render_roles(%{roles: user.roles})

    %{data:
      %{
        user: user,
        jwt: jwt
      }
    }
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


  defp render_roles(json, %{roles: roles}) do
    Map.put(json, :roles, render_many(roles, PortalApi.V1.TermView, "term.json"))
  end
  defp render_roles(json, _) do
    json
  end
  defp render_user_category(json, %{user_category: user_category}) when is_map(user_category) do
    Map.put(json, :user_category, render_one(user_category, PortalApi.V1.TermView, "term.json"))
  end
  defp render_user_category(json, _) do
    json
  end
end
