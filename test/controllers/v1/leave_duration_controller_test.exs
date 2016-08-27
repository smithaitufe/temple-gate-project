defmodule PortalApi.V1.LeaveDurationControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.LeaveDuration
  @valid_attrs %{duration: 42, maximum_grade_level: 42, minimum_grade_level: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, leave_duration_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    leave_duration = Repo.insert! %LeaveDuration{}
    conn = get conn, leave_duration_path(conn, :show, leave_duration)
    assert json_response(conn, 200)["data"] == %{"id" => leave_duration.id,
      "minimum_grade_level" => leave_duration.minimum_grade_level,
      "maximum_grade_level" => leave_duration.maximum_grade_level,
      "duration" => leave_duration.duration,
      "leave_track_type_id" => leave_duration.leave_track_type_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, leave_duration_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, leave_duration_path(conn, :create), leave_duration: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(LeaveDuration, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, leave_duration_path(conn, :create), leave_duration: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    leave_duration = Repo.insert! %LeaveDuration{}
    conn = put conn, leave_duration_path(conn, :update, leave_duration), leave_duration: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(LeaveDuration, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    leave_duration = Repo.insert! %LeaveDuration{}
    conn = put conn, leave_duration_path(conn, :update, leave_duration), leave_duration: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    leave_duration = Repo.insert! %LeaveDuration{}
    conn = delete conn, leave_duration_path(conn, :delete, leave_duration)
    assert response(conn, 204)
    refute Repo.get(LeaveDuration, leave_duration.id)
  end
end
