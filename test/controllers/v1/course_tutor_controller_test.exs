defmodule PortalApi.V1.CourseTutorControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.CourseTutor
  @valid_attrs %{}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, course_tutor_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    course_tutor = Repo.insert! %CourseTutor{}
    conn = get conn, course_tutor_path(conn, :show, course_tutor)
    assert json_response(conn, 200)["data"] == %{"id" => course_tutor.id,
      "course_id" => course_tutor.course_id,
      "staff_id" => course_tutor.staff_id,
      "academic_session_id" => course_tutor.academic_session_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, course_tutor_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, course_tutor_path(conn, :create), course_tutor: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(CourseTutor, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, course_tutor_path(conn, :create), course_tutor: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    course_tutor = Repo.insert! %CourseTutor{}
    conn = put conn, course_tutor_path(conn, :update, course_tutor), course_tutor: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(CourseTutor, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    course_tutor = Repo.insert! %CourseTutor{}
    conn = put conn, course_tutor_path(conn, :update, course_tutor), course_tutor: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    course_tutor = Repo.insert! %CourseTutor{}
    conn = delete conn, course_tutor_path(conn, :delete, course_tutor)
    assert response(conn, 204)
    refute Repo.get(CourseTutor, course_tutor.id)
  end
end
