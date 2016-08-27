defmodule PortalApi.V1.StaffLeaveEntitlementControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StaffLeaveEntitlement
  @valid_attrs %{entitled_leave: "some content", remaining_leave: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, staff_leave_entitlement_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    staff_leave_entitlement = Repo.insert! %StaffLeaveEntitlement{}
    conn = get conn, staff_leave_entitlement_path(conn, :show, staff_leave_entitlement)
    assert json_response(conn, 200)["data"] == %{"id" => staff_leave_entitlement.id,
      "staff_id" => staff_leave_entitlement.staff_id,
      "leave_track_type_id" => staff_leave_entitlement.leave_track_type_id,
      "entitled_leave" => staff_leave_entitlement.entitled_leave,
      "remaining_leave" => staff_leave_entitlement.remaining_leave}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, staff_leave_entitlement_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, staff_leave_entitlement_path(conn, :create), staff_leave_entitlement: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StaffLeaveEntitlement, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, staff_leave_entitlement_path(conn, :create), staff_leave_entitlement: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    staff_leave_entitlement = Repo.insert! %StaffLeaveEntitlement{}
    conn = put conn, staff_leave_entitlement_path(conn, :update, staff_leave_entitlement), staff_leave_entitlement: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StaffLeaveEntitlement, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    staff_leave_entitlement = Repo.insert! %StaffLeaveEntitlement{}
    conn = put conn, staff_leave_entitlement_path(conn, :update, staff_leave_entitlement), staff_leave_entitlement: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    staff_leave_entitlement = Repo.insert! %StaffLeaveEntitlement{}
    conn = delete conn, staff_leave_entitlement_path(conn, :delete, staff_leave_entitlement)
    assert response(conn, 204)
    refute Repo.get(StaffLeaveEntitlement, staff_leave_entitlement.id)
  end
end
