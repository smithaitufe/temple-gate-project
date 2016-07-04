defmodule PortalApi.V1.LocalGovernmentAreaControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.LocalGovernmentArea
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, local_government_area_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    local_government_area = Repo.insert! %LocalGovernmentArea{}
    conn = get conn, local_government_area_path(conn, :show, local_government_area)
    assert json_response(conn, 200)["data"] == %{"id" => local_government_area.id,
      "name" => local_government_area.name,
      "state_id" => local_government_area.state_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, local_government_area_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, local_government_area_path(conn, :create), local_government_area: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(LocalGovernmentArea, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, local_government_area_path(conn, :create), local_government_area: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    local_government_area = Repo.insert! %LocalGovernmentArea{}
    conn = put conn, local_government_area_path(conn, :update, local_government_area), local_government_area: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(LocalGovernmentArea, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    local_government_area = Repo.insert! %LocalGovernmentArea{}
    conn = put conn, local_government_area_path(conn, :update, local_government_area), local_government_area: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    local_government_area = Repo.insert! %LocalGovernmentArea{}
    conn = delete conn, local_government_area_path(conn, :delete, local_government_area)
    assert response(conn, 204)
    refute Repo.get(LocalGovernmentArea, local_government_area.id)
  end
end
