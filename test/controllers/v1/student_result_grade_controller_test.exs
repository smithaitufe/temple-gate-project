defmodule PortalApi.V1.StudentResultGradeControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StudentResultGrade
  @valid_attrs %{grade: "some content", score: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_result_grade_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    student_result_grade = Repo.insert! %StudentResultGrade{}
    conn = get conn, student_result_grade_path(conn, :show, student_result_grade)
    assert json_response(conn, 200)["data"] == %{"id" => student_result_grade.id,
      "student_result_id" => student_result_grade.student_result_id,
      "course_id" => student_result_grade.course_id,
      "score" => student_result_grade.score,
      "grade_id" => student_result_grade.grade_id,
      "grade" => student_result_grade.grade}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, student_result_grade_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, student_result_grade_path(conn, :create), student_result_grade: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StudentResultGrade, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_result_grade_path(conn, :create), student_result_grade: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    student_result_grade = Repo.insert! %StudentResultGrade{}
    conn = put conn, student_result_grade_path(conn, :update, student_result_grade), student_result_grade: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StudentResultGrade, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    student_result_grade = Repo.insert! %StudentResultGrade{}
    conn = put conn, student_result_grade_path(conn, :update, student_result_grade), student_result_grade: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    student_result_grade = Repo.insert! %StudentResultGrade{}
    conn = delete conn, student_result_grade_path(conn, :delete, student_result_grade)
    assert response(conn, 204)
    refute Repo.get(StudentResultGrade, student_result_grade.id)
  end
end
