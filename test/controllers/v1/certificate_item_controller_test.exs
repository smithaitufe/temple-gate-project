defmodule PortalApi.V1.CertificateItemControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.CertificateItem
  @valid_attrs %{}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, certificate_item_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    certificate_item = Repo.insert! %CertificateItem{}
    conn = get conn, certificate_item_path(conn, :show, certificate_item)
    assert json_response(conn, 200)["data"] == %{"id" => certificate_item.id,
      "student_certificate_id" => certificate_item.student_certificate_id,
      "subject_id" => certificate_item.subject_id,
      "grade_id" => certificate_item.grade_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, certificate_item_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, certificate_item_path(conn, :create), certificate_item: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(CertificateItem, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, certificate_item_path(conn, :create), certificate_item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    certificate_item = Repo.insert! %CertificateItem{}
    conn = put conn, certificate_item_path(conn, :update, certificate_item), certificate_item: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(CertificateItem, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    certificate_item = Repo.insert! %CertificateItem{}
    conn = put conn, certificate_item_path(conn, :update, certificate_item), certificate_item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    certificate_item = Repo.insert! %CertificateItem{}
    conn = delete conn, certificate_item_path(conn, :delete, certificate_item)
    assert response(conn, 204)
    refute Repo.get(CertificateItem, certificate_item.id)
  end
end
