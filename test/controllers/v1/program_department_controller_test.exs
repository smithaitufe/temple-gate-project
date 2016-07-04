defmodule PortalApi.V1.ProgramDepartmentControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.ProgramDepartment
  @valid_attrs %{}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, program_department_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    program_department = Repo.insert! %ProgramDepartment{}
    conn = get conn, program_department_path(conn, :show, program_department)
    assert json_response(conn, 200)["data"] == %{"id" => program_department.id,
      "program_id" => program_department.program_id,
      "department_id" => program_department.department_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, program_department_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, program_department_path(conn, :create), program_department: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ProgramDepartment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, program_department_path(conn, :create), program_department: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    program_department = Repo.insert! %ProgramDepartment{}
    conn = put conn, program_department_path(conn, :update, program_department), program_department: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ProgramDepartment, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    program_department = Repo.insert! %ProgramDepartment{}
    conn = put conn, program_department_path(conn, :update, program_department), program_department: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    program_department = Repo.insert! %ProgramDepartment{}
    conn = delete conn, program_department_path(conn, :delete, program_department)
    assert response(conn, 204)
    refute Repo.get(ProgramDepartment, program_department.id)
  end
end
