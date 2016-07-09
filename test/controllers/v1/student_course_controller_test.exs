defmodule PortalApi.V1.StudentCourseControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StudentCourse
  @valid_attrs %{}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_course_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    student_course = Repo.insert! %StudentCourse{}
    conn = get conn, student_course_path(conn, :show, student_course)
    assert json_response(conn, 200)["data"] == %{"id" => student_course.id,
      "course_id" => student_course.course_id,
      "student_id" => student_course.student_id,
      "academic_session_id" => student_course.academic_session_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, student_course_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, student_course_path(conn, :create), student_course: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StudentCourse, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_course_path(conn, :create), student_course: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    student_course = Repo.insert! %StudentCourse{}
    conn = put conn, student_course_path(conn, :update, student_course), student_course: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StudentCourse, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    student_course = Repo.insert! %StudentCourse{}
    conn = put conn, student_course_path(conn, :update, student_course), student_course: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    student_course = Repo.insert! %StudentCourse{}
    conn = delete conn, student_course_path(conn, :delete, student_course)
    assert response(conn, 204)
    refute Repo.get(StudentCourse, student_course.id)
  end
end
