defmodule PortalApi.V1.StudentResultControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StudentResult
  @valid_attrs %{number_failed: 42, number_passed: 42, promoted: true, total_point_average: "120.5", total_score: "120.5", total_units: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_result_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    student_result = Repo.insert! %StudentResult{}
    conn = get conn, student_result_path(conn, :show, student_result)
    assert json_response(conn, 200)["data"] == %{"id" => student_result.id,
      "academic_session_id" => student_result.academic_session_id,
      "student_id" => student_result.student_id,
      "level_id" => student_result.level_id,
      "semester_id" => student_result.semester_id,
      "total_units" => student_result.total_units,
      "total_score" => student_result.total_score,
      "total_point_average" => student_result.total_point_average,
      "number_passed" => student_result.number_passed,
      "number_failed" => student_result.number_failed,
      "promoted" => student_result.promoted}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, student_result_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, student_result_path(conn, :create), student_result: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StudentResult, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_result_path(conn, :create), student_result: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    student_result = Repo.insert! %StudentResult{}
    conn = put conn, student_result_path(conn, :update, student_result), student_result: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StudentResult, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    student_result = Repo.insert! %StudentResult{}
    conn = put conn, student_result_path(conn, :update, student_result), student_result: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    student_result = Repo.insert! %StudentResult{}
    conn = delete conn, student_result_path(conn, :delete, student_result)
    assert response(conn, 204)
    refute Repo.get(StudentResult, student_result.id)
  end
end
