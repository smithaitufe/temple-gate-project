defmodule PortalApi.V1.LevelControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.Level
  @valid_attrs %{description: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, level_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    level = Repo.insert! %Level{}
    conn = get conn, level_path(conn, :show, level)
    assert json_response(conn, 200)["data"] == %{"id" => level.id,
      "description" => level.description,
      "program_id" => level.program_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, level_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, level_path(conn, :create), level: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Level, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, level_path(conn, :create), level: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    level = Repo.insert! %Level{}
    conn = put conn, level_path(conn, :update, level), level: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Level, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    level = Repo.insert! %Level{}
    conn = put conn, level_path(conn, :update, level), level: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    level = Repo.insert! %Level{}
    conn = delete conn, level_path(conn, :delete, level)
    assert response(conn, 204)
    refute Repo.get(Level, level.id)
  end
end
