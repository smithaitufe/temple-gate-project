defmodule PortalApi.V1.StudentCourseGradingControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StudentCourseGrading
  @valid_attrs %{ca: "120.5", exam: "120.5", grade_point: "120.5", letter: "some content", total: "120.5", weight: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_course_grading_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    student_course_grading = Repo.insert! %StudentCourseGrading{}
    conn = get conn, student_course_grading_path(conn, :show, student_course_grading)
    assert json_response(conn, 200)["data"] == %{"id" => student_course_grading.id,
      "student_course_id" => student_course_grading.student_course_id,
      "exam" => student_course_grading.exam,
      "ca" => student_course_grading.ca,
      "total" => student_course_grading.total,
      "letter" => student_course_grading.letter,
      "weight" => student_course_grading.weight,
      "grade_point" => student_course_grading.grade_point,
      "grade_id" => student_course_grading.grade_id,
      "uploaded_by_staff_id" => student_course_grading.uploaded_by_staff_id,
      "edited_by_staff_id" => student_course_grading.edited_by_staff_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, student_course_grading_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, student_course_grading_path(conn, :create), student_course_grading: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StudentCourseGrading, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_course_grading_path(conn, :create), student_course_grading: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    student_course_grading = Repo.insert! %StudentCourseGrading{}
    conn = put conn, student_course_grading_path(conn, :update, student_course_grading), student_course_grading: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StudentCourseGrading, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    student_course_grading = Repo.insert! %StudentCourseGrading{}
    conn = put conn, student_course_grading_path(conn, :update, student_course_grading), student_course_grading: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    student_course_grading = Repo.insert! %StudentCourseGrading{}
    conn = delete conn, student_course_grading_path(conn, :delete, student_course_grading)
    assert response(conn, 204)
    refute Repo.get(StudentCourseGrading, student_course_grading.id)
  end
end
