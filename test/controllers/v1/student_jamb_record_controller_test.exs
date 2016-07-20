defmodule PortalApi.V1.StudentJambRecordControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StudentJambRecord
  @valid_attrs %{registration_no: "some content", score: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_jamb_record_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    student_jamb_record = Repo.insert! %StudentJambRecord{}
    conn = get conn, student_jamb_record_path(conn, :show, student_jamb_record)
    assert json_response(conn, 200)["data"] == %{"id" => student_jamb_record.id,
      "student_id" => student_jamb_record.student_id,
      "score" => student_jamb_record.score,
      "registration_no" => student_jamb_record.registration_no}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, student_jamb_record_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, student_jamb_record_path(conn, :create), student_jamb_record: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StudentJambRecord, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_jamb_record_path(conn, :create), student_jamb_record: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    student_jamb_record = Repo.insert! %StudentJambRecord{}
    conn = put conn, student_jamb_record_path(conn, :update, student_jamb_record), student_jamb_record: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StudentJambRecord, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    student_jamb_record = Repo.insert! %StudentJambRecord{}
    conn = put conn, student_jamb_record_path(conn, :update, student_jamb_record), student_jamb_record: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    student_jamb_record = Repo.insert! %StudentJambRecord{}
    conn = delete conn, student_jamb_record_path(conn, :delete, student_jamb_record)
    assert response(conn, 204)
    refute Repo.get(StudentJambRecord, student_jamb_record.id)
  end
end
