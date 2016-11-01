defmodule PortalApi.V1.JobPostingControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.JobPosting
  @valid_attrs %{posted_by_user_id: 3, active: true, application_method: "some content", closing_date: "2010-04-17", opening_date: "2010-04-17"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, job_posting_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    job_posting = Repo.insert! %JobPosting{}
    conn = get conn, job_posting_path(conn, :show, job_posting)
    assert json_response(conn, 200)["data"] == %{"id" => job_posting.id,
      "opening_date" => job_posting.opening_date,
      "closing_date" => job_posting.closing_date,
      "posted_by_user_id" => job_posting.posted_by_user_id,
      "active" => job_posting.active,
      "application_method" => job_posting.application_method}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, job_posting_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, job_posting_path(conn, :create), job_posting: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(JobPosting, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, job_posting_path(conn, :create), job_posting: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    job_posting = Repo.insert! %JobPosting{}
    conn = put conn, job_posting_path(conn, :update, job_posting), job_posting: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(JobPosting, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    job_posting = Repo.insert! %JobPosting{}
    conn = put conn, job_posting_path(conn, :update, job_posting), job_posting: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    job_posting = Repo.insert! %JobPosting{}
    conn = delete conn, job_posting_path(conn, :delete, job_posting)
    assert response(conn, 204)
    refute Repo.get(JobPosting, job_posting.id)
  end
end
