defmodule PortalApi.V1.ProgramApplicationControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.ProgramApplication
  @valid_attrs %{active: true, admitted: true}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, program_application_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    program_application = Repo.insert! %ProgramApplication{}
    conn = get conn, program_application_path(conn, :show, program_application)
    assert json_response(conn, 200)["data"] == %{"id" => program_application.id,
      "applicant_user_id" => program_application.applicant_user_id,
      "program_id" => program_application.program_id,
      "department_id" => program_application.department_id,
      "level_id" => program_application.level_id,
      "entry_mode_id" => program_application.entry_mode_id,
      "academic_session_id" => program_application.academic_session_id,
      "admitted" => program_application.admitted,
      "active" => program_application.active}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, program_application_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, program_application_path(conn, :create), program_application: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ProgramApplication, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, program_application_path(conn, :create), program_application: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    program_application = Repo.insert! %ProgramApplication{}
    conn = put conn, program_application_path(conn, :update, program_application), program_application: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ProgramApplication, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    program_application = Repo.insert! %ProgramApplication{}
    conn = put conn, program_application_path(conn, :update, program_application), program_application: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    program_application = Repo.insert! %ProgramApplication{}
    conn = delete conn, program_application_path(conn, :delete, program_application)
    assert response(conn, 204)
    refute Repo.get(ProgramApplication, program_application.id)
  end
end
