defmodule PortalApi.V1.UserRoleControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.UserRole
  @valid_attrs %{default: true}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_role_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user_role = Repo.insert! %UserRole{}
    conn = get conn, user_role_path(conn, :show, user_role)
    assert json_response(conn, 200)["data"] == %{"id" => user_role.id,
      "user_id" => user_role.user_id,
      "role_id" => user_role.role_id,
      "default" => user_role.default}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, user_role_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_role_path(conn, :create), user_role: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(UserRole, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_role_path(conn, :create), user_role: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user_role = Repo.insert! %UserRole{}
    conn = put conn, user_role_path(conn, :update, user_role), user_role: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(UserRole, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user_role = Repo.insert! %UserRole{}
    conn = put conn, user_role_path(conn, :update, user_role), user_role: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user_role = Repo.insert! %UserRole{}
    conn = delete conn, user_role_path(conn, :delete, user_role)
    assert response(conn, 204)
    refute Repo.get(UserRole, user_role.id)
  end
end
