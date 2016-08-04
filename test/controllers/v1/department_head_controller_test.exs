defmodule PortalApi.V1.DepartmentHeadControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.DepartmentHead
  @valid_attrs %{active: true, appointment_date: "2010-04-17", effective_date: "2010-04-17", end_date: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, department_head_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    department_head = Repo.insert! %DepartmentHead{}
    conn = get conn, department_head_path(conn, :show, department_head)
    assert json_response(conn, 200)["data"] == %{"id" => department_head.id,
      "department_id" => department_head.department_id,
      "staff_id" => department_head.staff_id,
      "active" => department_head.active,
      "appointment_date" => department_head.appointment_date,
      "effective_date" => department_head.effective_date,
      "end_date" => department_head.end_date}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, department_head_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, department_head_path(conn, :create), department_head: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(DepartmentHead, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, department_head_path(conn, :create), department_head: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    department_head = Repo.insert! %DepartmentHead{}
    conn = put conn, department_head_path(conn, :update, department_head), department_head: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(DepartmentHead, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    department_head = Repo.insert! %DepartmentHead{}
    conn = put conn, department_head_path(conn, :update, department_head), department_head: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    department_head = Repo.insert! %DepartmentHead{}
    conn = delete conn, department_head_path(conn, :delete, department_head)
    assert response(conn, 204)
    refute Repo.get(DepartmentHead, department_head.id)
  end
end
