defmodule PortalApi.V1.FacultyHeadControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.FacultyHead
  @valid_attrs %{active: true, appointment_date: "2010-04-17", effective_date: "2010-04-17", end_date: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, faculty_head_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    faculty_head = Repo.insert! %FacultyHead{}
    conn = get conn, faculty_head_path(conn, :show, faculty_head)
    assert json_response(conn, 200)["data"] == %{"id" => faculty_head.id,
      "faculty_id" => faculty_head.faculty_id,
      "staff_id" => faculty_head.staff_id,
      "active" => faculty_head.active,
      "appointment_date" => faculty_head.appointment_date,
      "effective_date" => faculty_head.effective_date,
      "end_date" => faculty_head.end_date}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, faculty_head_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, faculty_head_path(conn, :create), faculty_head: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(FacultyHead, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, faculty_head_path(conn, :create), faculty_head: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    faculty_head = Repo.insert! %FacultyHead{}
    conn = put conn, faculty_head_path(conn, :update, faculty_head), faculty_head: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(FacultyHead, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    faculty_head = Repo.insert! %FacultyHead{}
    conn = put conn, faculty_head_path(conn, :update, faculty_head), faculty_head: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    faculty_head = Repo.insert! %FacultyHead{}
    conn = delete conn, faculty_head_path(conn, :delete, faculty_head)
    assert response(conn, 204)
    refute Repo.get(FacultyHead, faculty_head.id)
  end
end
