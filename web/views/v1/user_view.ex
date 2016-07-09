defmodule PortalApi.V1.UserView do
  use PortalApi.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, PortalApi.V1.UserView, "user.json", as: :user)}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, PortalApi.V1.UserView, "user.json", as: :user)}
  end


  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      user_name: user.user_name,
      email: user.email,
      user_category_id: user.user_category_id
    }
  end

  def render("error.json", %{changeset: changeset}) do
    errors = Enum.map(changeset.errors, fn {field, detail} ->
      %{} |> Map.put(field, render_detail(detail))
    end)

    %{
      errors: errors
    }
  end
  def render("examinee_uploaded.json", _) do
    %{ok: true}
  end

  defp render_detail({message, values}) do
    Enum.reduce(values, message, fn {k, v}, acc -> String.replace(acc, "%{#{k}}", to_string(v)) end)
  end

  defp render_detail(message) do
    message
  end
end
