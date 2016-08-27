defmodule PortalApi.V1.StaffLeaveRequestControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StaffLeaveRequest
  @valid_attrs %{approved: true, approved_end_date: "2010-04-17", approved_start_date: "2010-04-17", closed: true, closed_at: "2010-04-17 14:00:00", details: "some content", no_of_days: 42, proposed_end_date: "2010-04-17", proposed_start_date: "2010-04-17", read: true}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, staff_leave_request_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    staff_leave_request = Repo.insert! %StaffLeaveRequest{}
    conn = get conn, staff_leave_request_path(conn, :show, staff_leave_request)
    assert json_response(conn, 200)["data"] == %{"id" => staff_leave_request.id,
      "staff_id" => staff_leave_request.staff_id,
      "proposed_start_date" => staff_leave_request.proposed_start_date,
      "proposed_end_date" => staff_leave_request.proposed_end_date,
      "read" => staff_leave_request.read,
      "closed_by_staff_id" => staff_leave_request.closed_by_staff_id,
      "details" => staff_leave_request.details,
      "approved" => staff_leave_request.approved,
      "approved_start_date" => staff_leave_request.approved_start_date,
      "approved_end_date" => staff_leave_request.approved_end_date,
      "no_of_days" => staff_leave_request.no_of_days,
      "closed" => staff_leave_request.closed,
      "closed_at" => staff_leave_request.closed_at}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, staff_leave_request_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, staff_leave_request_path(conn, :create), staff_leave_request: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StaffLeaveRequest, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, staff_leave_request_path(conn, :create), staff_leave_request: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    staff_leave_request = Repo.insert! %StaffLeaveRequest{}
    conn = put conn, staff_leave_request_path(conn, :update, staff_leave_request), staff_leave_request: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StaffLeaveRequest, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    staff_leave_request = Repo.insert! %StaffLeaveRequest{}
    conn = put conn, staff_leave_request_path(conn, :update, staff_leave_request), staff_leave_request: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    staff_leave_request = Repo.insert! %StaffLeaveRequest{}
    conn = delete conn, staff_leave_request_path(conn, :delete, staff_leave_request)
    assert response(conn, 204)
    refute Repo.get(StaffLeaveRequest, staff_leave_request.id)
  end
end
