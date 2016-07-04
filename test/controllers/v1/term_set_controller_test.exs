defmodule PortalApi.V1.TermSetControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.TermSet
  @valid_attrs %{display_name: "some content", name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, term_set_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    term_set = Repo.insert! %TermSet{}
    conn = get conn, term_set_path(conn, :show, term_set)
    assert json_response(conn, 200)["data"] == %{"id" => term_set.id,
      "name" => term_set.name,
      "display_name" => term_set.display_name}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, term_set_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, term_set_path(conn, :create), term_set: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(TermSet, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, term_set_path(conn, :create), term_set: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    term_set = Repo.insert! %TermSet{}
    conn = put conn, term_set_path(conn, :update, term_set), term_set: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(TermSet, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    term_set = Repo.insert! %TermSet{}
    conn = put conn, term_set_path(conn, :update, term_set), term_set: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    term_set = Repo.insert! %TermSet{}
    conn = delete conn, term_set_path(conn, :delete, term_set)
    assert response(conn, 204)
    refute Repo.get(TermSet, term_set.id)
  end
end
