defmodule PortalApi.V1.PostingControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.Posting
  @valid_attrs %{active: true}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, posting_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    posting = Repo.insert! %Posting{}
    conn = get conn, posting_path(conn, :show, posting)
    assert json_response(conn, 200)["data"] == %{"id" => posting.id,
      "staff_id" => posting.staff_id,
      "department_id" => posting.department_id,
      "salary_grade_step_id" => posting.salary_grade_step_id,
      "active" => posting.active,
      "job_title_id" => posting.job_title_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, posting_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, posting_path(conn, :create), posting: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Posting, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, posting_path(conn, :create), posting: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    posting = Repo.insert! %Posting{}
    conn = put conn, posting_path(conn, :update, posting), posting: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Posting, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    posting = Repo.insert! %Posting{}
    conn = put conn, posting_path(conn, :update, posting), posting: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    posting = Repo.insert! %Posting{}
    conn = delete conn, posting_path(conn, :delete, posting)
    assert response(conn, 204)
    refute Repo.get(Posting, posting.id)
  end
end
