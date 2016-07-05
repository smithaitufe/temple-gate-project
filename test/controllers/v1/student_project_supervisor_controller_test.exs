defmodule PortalApi.V1.StudentProjectSupervisorControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StudentProjectSupervisor
  @valid_attrs %{}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_project_supervisor_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    student_project_supervisor = Repo.insert! %StudentProjectSupervisor{}
    conn = get conn, student_project_supervisor_path(conn, :show, student_project_supervisor)
    assert json_response(conn, 200)["data"] == %{"id" => student_project_supervisor.id,
      "staff_id" => student_project_supervisor.staff_id,
      "student_id" => student_project_supervisor.student_id,
      "project_status_id" => student_project_supervisor.project_status_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, student_project_supervisor_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, student_project_supervisor_path(conn, :create), student_project_supervisor: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StudentProjectSupervisor, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_project_supervisor_path(conn, :create), student_project_supervisor: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    student_project_supervisor = Repo.insert! %StudentProjectSupervisor{}
    conn = put conn, student_project_supervisor_path(conn, :update, student_project_supervisor), student_project_supervisor: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StudentProjectSupervisor, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    student_project_supervisor = Repo.insert! %StudentProjectSupervisor{}
    conn = put conn, student_project_supervisor_path(conn, :update, student_project_supervisor), student_project_supervisor: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    student_project_supervisor = Repo.insert! %StudentProjectSupervisor{}
    conn = delete conn, student_project_supervisor_path(conn, :delete, student_project_supervisor)
    assert response(conn, 204)
    refute Repo.get(StudentProjectSupervisor, student_project_supervisor.id)
  end
end
