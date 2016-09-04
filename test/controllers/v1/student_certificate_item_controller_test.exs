defmodule PortalApi.V1.StudentCertificateItemControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StudentCertificateItem
  @valid_attrs %{}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_certificate_item_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    student_certificate_item = Repo.insert! %StudentCertificateItem{}
    conn = get conn, student_certificate_item_path(conn, :show, student_certificate_item)
    assert json_response(conn, 200)["data"] == %{"id" => student_certificate_item.id,
      "student_certificate_id" => student_certificate_item.student_certificate_id,
      "subject_id" => student_certificate_item.subject_id,
      "grade_id" => student_certificate_item.grade_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, student_certificate_item_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, student_certificate_item_path(conn, :create), student_certificate_item: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StudentCertificateItem, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_certificate_item_path(conn, :create), student_certificate_item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    student_certificate_item = Repo.insert! %StudentCertificateItem{}
    conn = put conn, student_certificate_item_path(conn, :update, student_certificate_item), student_certificate_item: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StudentCertificateItem, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    student_certificate_item = Repo.insert! %StudentCertificateItem{}
    conn = put conn, student_certificate_item_path(conn, :update, student_certificate_item), student_certificate_item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    student_certificate_item = Repo.insert! %StudentCertificateItem{}
    conn = delete conn, student_certificate_item_path(conn, :delete, student_certificate_item)
    assert response(conn, 204)
    refute Repo.get(StudentCertificateItem, student_certificate_item.id)
  end
end
