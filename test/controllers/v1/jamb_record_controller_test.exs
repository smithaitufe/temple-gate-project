defmodule PortalApi.V1.JambRecordControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.JambRecord
  @valid_attrs %{registration_no: "some content", score: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, jamb_record_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    jamb_record = Repo.insert! %JambRecord{}
    conn = get conn, jamb_record_path(conn, :show, jamb_record)
    assert json_response(conn, 200)["data"] == %{"id" => jamb_record.id,
      "user_id" => jamb_record.user_id,
      "score" => jamb_record.score,
      "registration_no" => jamb_record.registration_no}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, jamb_record_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, jamb_record_path(conn, :create), jamb_record: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(JambRecord, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, jamb_record_path(conn, :create), jamb_record: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    jamb_record = Repo.insert! %JambRecord{}
    conn = put conn, jamb_record_path(conn, :update, jamb_record), jamb_record: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(JambRecord, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    jamb_record = Repo.insert! %JambRecord{}
    conn = put conn, jamb_record_path(conn, :update, jamb_record), jamb_record: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    jamb_record = Repo.insert! %JambRecord{}
    conn = delete conn, jamb_record_path(conn, :delete, jamb_record)
    assert response(conn, 204)
    refute Repo.get(JambRecord, jamb_record.id)
  end
end
