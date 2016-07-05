defmodule PortalApi.V1.StaffPostingControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StaffPosting
  @valid_attrs %{active: true}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, staff_posting_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    staff_posting = Repo.insert! %StaffPosting{}
    conn = get conn, staff_posting_path(conn, :show, staff_posting)
    assert json_response(conn, 200)["data"] == %{"id" => staff_posting.id,
      "staff_id" => staff_posting.staff_id,
      "department_id" => staff_posting.department_id,
      "salary_grade_step_id" => staff_posting.salary_grade_step_id,
      "active" => staff_posting.active,
      "job_title_id" => staff_posting.job_title_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, staff_posting_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, staff_posting_path(conn, :create), staff_posting: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StaffPosting, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, staff_posting_path(conn, :create), staff_posting: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    staff_posting = Repo.insert! %StaffPosting{}
    conn = put conn, staff_posting_path(conn, :update, staff_posting), staff_posting: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StaffPosting, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    staff_posting = Repo.insert! %StaffPosting{}
    conn = put conn, staff_posting_path(conn, :update, staff_posting), staff_posting: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    staff_posting = Repo.insert! %StaffPosting{}
    conn = delete conn, staff_posting_path(conn, :delete, staff_posting)
    assert response(conn, 204)
    refute Repo.get(StaffPosting, staff_posting.id)
  end
end
