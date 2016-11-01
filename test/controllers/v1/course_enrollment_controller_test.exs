defmodule PortalApi.V1.CourseEnrollmentControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.CourseEnrollment
  @valid_attrs %{}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, course_enrollment_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    course_enrollment = Repo.insert! %CourseEnrollment{}
    conn = get conn, course_enrollment_path(conn, :show, course_enrollment)
    assert json_response(conn, 200)["data"] == %{"id" => course_enrollment.id,
      "course_id" => course_enrollment.course_id,
      "student_id" => course_enrollment.student_id,
      "academic_session_id" => course_enrollment.academic_session_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, course_enrollment_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, course_enrollment_path(conn, :create), course_enrollment: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(CourseEnrollment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, course_enrollment_path(conn, :create), course_enrollment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    course_enrollment = Repo.insert! %CourseEnrollment{}
    conn = put conn, course_enrollment_path(conn, :update, course_enrollment), course_enrollment: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(CourseEnrollment, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    course_enrollment = Repo.insert! %CourseEnrollment{}
    conn = put conn, course_enrollment_path(conn, :update, course_enrollment), course_enrollment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    course_enrollment = Repo.insert! %CourseEnrollment{}
    conn = delete conn, course_enrollment_path(conn, :delete, course_enrollment)
    assert response(conn, 204)
    refute Repo.get(CourseEnrollment, course_enrollment.id)
  end
end
