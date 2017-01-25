defmodule PortalApi.V1.PostPrimaryCertificateItemControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.PostPrimaryCertificateItem
  @valid_attrs %{}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_primary_certificate_item_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    post_primary_certificate_item = Repo.insert! %PostPrimaryCertificateItem{}
    conn = get conn, post_primary_certificate_item_path(conn, :show, post_primary_certificate_item)
    assert json_response(conn, 200)["data"] == %{"id" => post_primary_certificate_item.id,
      "student_certificate_id" => post_primary_certificate_item.student_certificate_id,
      "subject_id" => post_primary_certificate_item.subject_id,
      "grade_id" => post_primary_certificate_item.grade_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, post_primary_certificate_item_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, post_primary_certificate_item_path(conn, :create), post_primary_certificate_item: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(PostPrimaryCertificateItem, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, post_primary_certificate_item_path(conn, :create), post_primary_certificate_item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    post_primary_certificate_item = Repo.insert! %PostPrimaryCertificateItem{}
    conn = put conn, post_primary_certificate_item_path(conn, :update, post_primary_certificate_item), post_primary_certificate_item: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(PostPrimaryCertificateItem, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    post_primary_certificate_item = Repo.insert! %PostPrimaryCertificateItem{}
    conn = put conn, post_primary_certificate_item_path(conn, :update, post_primary_certificate_item), post_primary_certificate_item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    post_primary_certificate_item = Repo.insert! %PostPrimaryCertificateItem{}
    conn = delete conn, post_primary_certificate_item_path(conn, :delete, post_primary_certificate_item)
    assert response(conn, 204)
    refute Repo.get(PostPrimaryCertificateItem, post_primary_certificate_item.id)
  end
end
