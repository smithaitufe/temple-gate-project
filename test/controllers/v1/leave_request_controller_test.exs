defmodule PortalApi.V1.LeaveRequestControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.LeaveRequest
  @valid_attrs %{approved: true, approved_end_date: "2010-04-17", approved_start_date: "2010-04-17", closed: true, closed_at: "2010-04-17 14:00:00", details: "some content", no_of_days: 42, proposed_end_date: "2010-04-17", proposed_start_date: "2010-04-17", read: true}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, leave_request_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    leave_request = Repo.insert! %LeaveRequest{}
    conn = get conn, leave_request_path(conn, :show, leave_request)
    assert json_response(conn, 200)["data"] == %{"id" => leave_request.id,
      "staff_id" => leave_request.staff_id,
      "proposed_start_date" => leave_request.proposed_start_date,
      "proposed_end_date" => leave_request.proposed_end_date,
      "read" => leave_request.read,
      "closed_by_staff_id" => leave_request.closed_by_staff_id,
      "details" => leave_request.details,
      "approved" => leave_request.approved,
      "approved_start_date" => leave_request.approved_start_date,
      "approved_end_date" => leave_request.approved_end_date,
      "no_of_days" => leave_request.no_of_days,
      "closed" => leave_request.closed,
      "closed_at" => leave_request.closed_at}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, leave_request_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, leave_request_path(conn, :create), leave_request: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(LeaveRequest, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, leave_request_path(conn, :create), leave_request: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    leave_request = Repo.insert! %LeaveRequest{}
    conn = put conn, leave_request_path(conn, :update, leave_request), leave_request: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(LeaveRequest, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    leave_request = Repo.insert! %LeaveRequest{}
    conn = put conn, leave_request_path(conn, :update, leave_request), leave_request: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    leave_request = Repo.insert! %LeaveRequest{}
    conn = delete conn, leave_request_path(conn, :delete, leave_request)
    assert response(conn, 204)
    refute Repo.get(LeaveRequest, leave_request.id)
  end
end
