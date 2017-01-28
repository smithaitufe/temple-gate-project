defmodule PortalApi.V1.ProgramApplicationJambRecordControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.ProgramApplicationJambRecord
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, program_application_jamb_record_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    program_application_jamb_record = Repo.insert! %ProgramApplicationJambRecord{}
    conn = get conn, program_application_jamb_record_path(conn, :show, program_application_jamb_record)
    assert json_response(conn, 200)["data"] == %{"id" => program_application_jamb_record.id,
      "jamb_record_id" => program_application_jamb_record.jamb_record_id,
      "program_application_id" => program_application_jamb_record.program_application_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, program_application_jamb_record_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, program_application_jamb_record_path(conn, :create), program_application_jamb_record: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ProgramApplicationJambRecord, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, program_application_jamb_record_path(conn, :create), program_application_jamb_record: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    program_application_jamb_record = Repo.insert! %ProgramApplicationJambRecord{}
    conn = put conn, program_application_jamb_record_path(conn, :update, program_application_jamb_record), program_application_jamb_record: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ProgramApplicationJambRecord, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    program_application_jamb_record = Repo.insert! %ProgramApplicationJambRecord{}
    conn = put conn, program_application_jamb_record_path(conn, :update, program_application_jamb_record), program_application_jamb_record: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    program_application_jamb_record = Repo.insert! %ProgramApplicationJambRecord{}
    conn = delete conn, program_application_jamb_record_path(conn, :delete, program_application_jamb_record)
    assert response(conn, 204)
    refute Repo.get(ProgramApplicationJambRecord, program_application_jamb_record.id)
  end
end
