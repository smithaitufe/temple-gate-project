defmodule PortalApi.V1.StudentAssignmentControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StudentAssignment
  @valid_attrs %{submission: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_assignment_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    student_assignment = Repo.insert! %StudentAssignment{}
    conn = get conn, student_assignment_path(conn, :show, student_assignment)
    assert json_response(conn, 200)["data"] == %{"id" => student_assignment.id,
      "student_id" => student_assignment.student_id,
      "assignment_id" => student_assignment.assignment_id,
      "submission" => student_assignment.submission}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, student_assignment_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, student_assignment_path(conn, :create), student_assignment: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StudentAssignment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_assignment_path(conn, :create), student_assignment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    student_assignment = Repo.insert! %StudentAssignment{}
    conn = put conn, student_assignment_path(conn, :update, student_assignment), student_assignment: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StudentAssignment, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    student_assignment = Repo.insert! %StudentAssignment{}
    conn = put conn, student_assignment_path(conn, :update, student_assignment), student_assignment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    student_assignment = Repo.insert! %StudentAssignment{}
    conn = delete conn, student_assignment_path(conn, :delete, student_assignment)
    assert response(conn, 204)
    refute Repo.get(StudentAssignment, student_assignment.id)
  end
end
