defmodule PortalApi.V1.StudentControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.Student
  @valid_attrs %{birth_date: "2010-04-17", email: "some content", first_name: "some content", last_name: "some content", matriculation_no: "some content", middle_name: "some content", phone_number: "some content", registration_no: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    student = Repo.insert! %Student{}
    conn = get conn, student_path(conn, :show, student)
    assert json_response(conn, 200)["data"] == %{"id" => student.id,
      "first_name" => student.first_name,
      "last_name" => student.last_name,
      "middle_name" => student.middle_name,
      "birth_date" => student.birth_date,
      "gender_id" => student.gender_id,
      "marital_status_id" => student.marital_status_id,
      "phone_number" => student.phone_number,
      "email" => student.email,
      "registration_no" => student.registration_no,
      "matriculation_no" => student.matriculation_no,
      "academic_session_id" => student.academic_session_id,
      "department_id" => student.department_id,
      "program_id" => student.program_id,
      "level_id" => student.level_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, student_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, student_path(conn, :create), student: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Student, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_path(conn, :create), student: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    student = Repo.insert! %Student{}
    conn = put conn, student_path(conn, :update, student), student: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Student, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    student = Repo.insert! %Student{}
    conn = put conn, student_path(conn, :update, student), student: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    student = Repo.insert! %Student{}
    conn = delete conn, student_path(conn, :delete, student)
    assert response(conn, 204)
    refute Repo.get(Student, student.id)
  end
end
