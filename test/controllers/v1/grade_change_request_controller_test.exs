defmodule PortalApi.V1.GradeChangeRequestControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.GradeChangeRequest
  @valid_attrs %{aapproved: true, approved_at: "2010-04-17 14:00:00", current_grade_letter: "some content", current_score: "120.5", previous_grade_letter: "some content", previous_score: "120.5", read: true, rejected: true}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, grade_change_request_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    grade_change_request = Repo.insert! %GradeChangeRequest{}
    conn = get conn, grade_change_request_path(conn, :show, grade_change_request)
    assert json_response(conn, 200)["data"] == %{"id" => grade_change_request.id,
      "student_course_id" => grade_change_request.student_course_id,
      "reason_id" => grade_change_request.reason_id,
      "previous_score" => grade_change_request.previous_score,
      "previous_grade_letter" => grade_change_request.previous_grade_letter,
      "previous_grade_id" => grade_change_request.previous_grade_id,
      "current_score" => grade_change_request.current_score,
      "current_grade_letter" => grade_change_request.current_grade_letter,
      "current_grade_id" => grade_change_request.current_grade_id,
      "requested_by" => grade_change_request.requested_by,
      "read" => grade_change_request.read,
      "aapproved" => grade_change_request.aapproved,
      "approved_by" => grade_change_request.approved_by,
      "approved_at" => grade_change_request.approved_at,
      "rejected" => grade_change_request.rejected,
      "rejection_reason_id" => grade_change_request.rejection_reason_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, grade_change_request_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, grade_change_request_path(conn, :create), grade_change_request: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(GradeChangeRequest, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, grade_change_request_path(conn, :create), grade_change_request: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    grade_change_request = Repo.insert! %GradeChangeRequest{}
    conn = put conn, grade_change_request_path(conn, :update, grade_change_request), grade_change_request: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(GradeChangeRequest, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    grade_change_request = Repo.insert! %GradeChangeRequest{}
    conn = put conn, grade_change_request_path(conn, :update, grade_change_request), grade_change_request: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    grade_change_request = Repo.insert! %GradeChangeRequest{}
    conn = delete conn, grade_change_request_path(conn, :delete, grade_change_request)
    assert response(conn, 204)
    refute Repo.get(GradeChangeRequest, grade_change_request.id)
  end
end
