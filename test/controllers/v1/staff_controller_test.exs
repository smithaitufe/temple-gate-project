defmodule PortalApi.V1.StaffControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.Staff
  @valid_attrs %{birth_date: "2010-04-17", first_name: "some content", last_name: "some content", middle_name: "some content", registration_no: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, staff_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    staff = Repo.insert! %Staff{}
    conn = get conn, staff_path(conn, :show, staff)
    assert json_response(conn, 200)["data"] == %{"id" => staff.id,
      "registration_no" => staff.registration_no,
      "last_name" => staff.last_name,
      "middle_name" => staff.middle_name,
      "first_name" => staff.first_name,
      "marital_status_id" => staff.marital_status_id,
      "gender_id" => staff.gender_id,
      "birth_date" => staff.birth_date,
      "local_government_area_id" => staff.local_government_area_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, staff_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, staff_path(conn, :create), staff: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Staff, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, staff_path(conn, :create), staff: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    staff = Repo.insert! %Staff{}
    conn = put conn, staff_path(conn, :update, staff), staff: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Staff, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    staff = Repo.insert! %Staff{}
    conn = put conn, staff_path(conn, :update, staff), staff: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    staff = Repo.insert! %Staff{}
    conn = delete conn, staff_path(conn, :delete, staff)
    assert response(conn, 204)
    refute Repo.get(Staff, staff.id)
  end
end
