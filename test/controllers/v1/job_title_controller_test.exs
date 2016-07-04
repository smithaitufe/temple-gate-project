defmodule PortalApi.V1.JobTitleControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.JobTitle
  @valid_attrs %{description: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, job_title_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    job_title = Repo.insert! %JobTitle{}
    conn = get conn, job_title_path(conn, :show, job_title)
    assert json_response(conn, 200)["data"] == %{"id" => job_title.id,
      "description" => job_title.description,
      "department_type_id" => job_title.department_type_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, job_title_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, job_title_path(conn, :create), job_title: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(JobTitle, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, job_title_path(conn, :create), job_title: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    job_title = Repo.insert! %JobTitle{}
    conn = put conn, job_title_path(conn, :update, job_title), job_title: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(JobTitle, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    job_title = Repo.insert! %JobTitle{}
    conn = put conn, job_title_path(conn, :update, job_title), job_title: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    job_title = Repo.insert! %JobTitle{}
    conn = delete conn, job_title_path(conn, :delete, job_title)
    assert response(conn, 204)
    refute Repo.get(JobTitle, job_title.id)
  end
end
