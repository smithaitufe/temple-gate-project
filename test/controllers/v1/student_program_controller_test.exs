defmodule PortalApi.V1.StudentProgramControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StudentProgram
  @valid_attrs %{}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_program_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    student_program = Repo.insert! %StudentProgram{}
    conn = get conn, student_program_path(conn, :show, student_program)
    assert json_response(conn, 200)["data"] == %{"id" => student_program.id,
      "student_id" => student_program.student_id,
      "program_id" => student_program.program_id,
      "department_id" => student_program.department_id,
      "level_id" => student_program.level_id,
      "academic_session_id" => student_program.academic_session_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, student_program_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, student_program_path(conn, :create), student_program: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StudentProgram, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_program_path(conn, :create), student_program: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    student_program = Repo.insert! %StudentProgram{}
    conn = put conn, student_program_path(conn, :update, student_program), student_program: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StudentProgram, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    student_program = Repo.insert! %StudentProgram{}
    conn = put conn, student_program_path(conn, :update, student_program), student_program: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    student_program = Repo.insert! %StudentProgram{}
    conn = delete conn, student_program_path(conn, :delete, student_program)
    assert response(conn, 204)
    refute Repo.get(StudentProgram, student_program.id)
  end
end
