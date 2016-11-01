defmodule PortalApi.V1.AssignmentControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.Assignment
  @valid_attrs %{course_id: 2, assigner_user_id: 20, closing_date: "2010-04-17", closing_time: "14:00:00", note: "some content", question: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, assignment_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    assignment = Repo.insert! %Assignment{}
    conn = get conn, assignment_path(conn, :show, assignment)
    assert json_response(conn, 200)["data"] == %{"id" => assignment.id,
      "assigner_user_id" => assignment.assigner_user_id,
      "course_id" => assignment.course_id,
      "question" => assignment.question,
      "note" => assignment.note,
      "closing_date" => assignment.closing_date,
      "closing_time" => assignment.closing_time}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, assignment_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, assignment_path(conn, :create), assignment: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Assignment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, assignment_path(conn, :create), assignment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    assignment = Repo.insert! %Assignment{}
    conn = put conn, assignment_path(conn, :update, assignment), assignment: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Assignment, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    assignment = Repo.insert! %Assignment{}
    conn = put conn, assignment_path(conn, :update, assignment), assignment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    assignment = Repo.insert! %Assignment{}
    conn = delete conn, assignment_path(conn, :delete, assignment)
    assert response(conn, 204)
    refute Repo.get(Assignment, assignment.id)
  end
end
