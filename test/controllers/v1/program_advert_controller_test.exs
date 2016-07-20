defmodule PortalApi.V1.ProgramAdvertControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.ProgramAdvert
  @valid_attrs %{active: true, closing_date: "2010-04-17", opening_date: "2010-04-17"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, program_advert_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    program_advert = Repo.insert! %ProgramAdvert{}
    conn = get conn, program_advert_path(conn, :show, program_advert)
    assert json_response(conn, 200)["data"] == %{"id" => program_advert.id,
      "program_id" => program_advert.program_id,
      "academic_session_id" => program_advert.academic_session_id,
      "opening_date" => program_advert.opening_date,
      "closing_date" => program_advert.closing_date,
      "active" => program_advert.active}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, program_advert_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, program_advert_path(conn, :create), program_advert: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ProgramAdvert, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, program_advert_path(conn, :create), program_advert: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    program_advert = Repo.insert! %ProgramAdvert{}
    conn = put conn, program_advert_path(conn, :update, program_advert), program_advert: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ProgramAdvert, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    program_advert = Repo.insert! %ProgramAdvert{}
    conn = put conn, program_advert_path(conn, :update, program_advert), program_advert: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    program_advert = Repo.insert! %ProgramAdvert{}
    conn = delete conn, program_advert_path(conn, :delete, program_advert)
    assert response(conn, 204)
    refute Repo.get(ProgramAdvert, program_advert.id)
  end
end
