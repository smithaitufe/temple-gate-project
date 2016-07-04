defmodule PortalApi.V1.CourseControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.Course
  @valid_attrs %{code: "some content", core: true, description: "some content", hours: 42, title: "some content", units: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, course_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    course = Repo.insert! %Course{}
    conn = get conn, course_path(conn, :show, course)
    assert json_response(conn, 200)["data"] == %{"id" => course.id,
      "department_id" => course.department_id,
      "level_id" => course.level_id,
      "semester_id" => course.semester_id,
      "code" => course.code,
      "title" => course.title,
      "units" => course.units,
      "hours" => course.hours,
      "core" => course.core,
      "description" => course.description}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, course_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, course_path(conn, :create), course: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Course, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, course_path(conn, :create), course: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    course = Repo.insert! %Course{}
    conn = put conn, course_path(conn, :update, course), course: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Course, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    course = Repo.insert! %Course{}
    conn = put conn, course_path(conn, :update, course), course: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    course = Repo.insert! %Course{}
    conn = delete conn, course_path(conn, :delete, course)
    assert response(conn, 204)
    refute Repo.get(Course, course.id)
  end
end
