defmodule PortalApi.V1.AcademicSessionControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.AcademicSession
  @valid_attrs %{closing_date: "2010-04-17", description: "some content", is_current: true, opening_date: "2010-04-17"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, academic_session_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    academic_session = Repo.insert! %AcademicSession{}
    conn = get conn, academic_session_path(conn, :show, academic_session)
    assert json_response(conn, 200)["data"] == %{"id" => academic_session.id,
      "opening_date" => academic_session.opening_date,
      "closing_date" => academic_session.closing_date,
      "description" => academic_session.description,
      "is_current" => academic_session.is_current}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, academic_session_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, academic_session_path(conn, :create), academic_session: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(AcademicSession, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, academic_session_path(conn, :create), academic_session: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    academic_session = Repo.insert! %AcademicSession{}
    conn = put conn, academic_session_path(conn, :update, academic_session), academic_session: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(AcademicSession, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    academic_session = Repo.insert! %AcademicSession{}
    conn = put conn, academic_session_path(conn, :update, academic_session), academic_session: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    academic_session = Repo.insert! %AcademicSession{}
    conn = delete conn, academic_session_path(conn, :delete, academic_session)
    assert response(conn, 204)
    refute Repo.get(AcademicSession, academic_session.id)
  end
end
