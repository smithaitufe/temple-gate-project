defmodule PortalApi.V1.CourseGradingControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.CourseGrading
  @valid_attrs %{ca: "120.5", exam: "120.5", grade_point: "120.5", letter: "some content", total: "120.5", weight: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, course_grading_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    course_grading = Repo.insert! %CourseGrading{}
    conn = get conn, course_grading_path(conn, :show, course_grading)
    assert json_response(conn, 200)["data"] == %{"id" => course_grading.id,
      "course_enrollment_id" => course_grading.course_enrollment_id,
      "exam" => course_grading.exam,
      "ca" => course_grading.ca,
      "total" => course_grading.total,
      "letter" => course_grading.letter,
      "weight" => course_grading.weight,
      "grade_point" => course_grading.grade_point,
      "grade_id" => course_grading.grade_id,
      "uploaded_by_user_id" => course_grading.uploaded_by_user_id,
      "modified_by_user_id" => course_grading.modified_by_user_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, course_grading_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, course_grading_path(conn, :create), course_grading: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(CourseGrading, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, course_grading_path(conn, :create), course_grading: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    course_grading = Repo.insert! %CourseGrading{}
    conn = put conn, course_grading_path(conn, :update, course_grading), course_grading: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(CourseGrading, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    course_grading = Repo.insert! %CourseGrading{}
    conn = put conn, course_grading_path(conn, :update, course_grading), course_grading: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    course_grading = Repo.insert! %CourseGrading{}
    conn = delete conn, course_grading_path(conn, :delete, course_grading)
    assert response(conn, 204)
    refute Repo.get(CourseGrading, course_grading.id)
  end
end
