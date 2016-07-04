defmodule PortalApi.V1.FacultyControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.Faculty
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, faculty_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    faculty = Repo.insert! %Faculty{}
    conn = get conn, faculty_path(conn, :show, faculty)
    assert json_response(conn, 200)["data"] == %{"id" => faculty.id,
      "name" => faculty.name,
      "faculty_type_id" => faculty.faculty_type_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, faculty_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, faculty_path(conn, :create), faculty: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Faculty, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, faculty_path(conn, :create), faculty: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    faculty = Repo.insert! %Faculty{}
    conn = put conn, faculty_path(conn, :update, faculty), faculty: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Faculty, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    faculty = Repo.insert! %Faculty{}
    conn = put conn, faculty_path(conn, :update, faculty), faculty: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    faculty = Repo.insert! %Faculty{}
    conn = delete conn, faculty_path(conn, :delete, faculty)
    assert response(conn, 204)
    refute Repo.get(Faculty, faculty.id)
  end
end
