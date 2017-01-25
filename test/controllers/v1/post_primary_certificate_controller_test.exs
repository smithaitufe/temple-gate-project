defmodule PortalApi.V1.PostPrimaryCertificateControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.PostPrimaryCertificate
  @valid_attrs %{user_id: 12, registration_no: "some content", year_obtained: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_primary_certificate_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    post_primary_certificate = Repo.insert! %PostPrimaryCertificate{}
    conn = get conn, post_primary_certificate_path(conn, :show, post_primary_certificate)
    assert json_response(conn, 200)["data"] == %{"id" => post_primary_certificate.id,
      "student_id" => post_primary_certificate.student_id,
      "examination_body_id" => post_primary_certificate.examination_body_id,
      "year_obtained" => post_primary_certificate.year_obtained,
      "registration_no" => post_primary_certificate.registration_no}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, post_primary_certificate_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, post_primary_certificate_path(conn, :create), post_primary_certificate: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(PostPrimaryCertificate, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, post_primary_certificate_path(conn, :create), post_primary_certificate: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    post_primary_certificate = Repo.insert! %PostPrimaryCertificate{}
    conn = put conn, post_primary_certificate_path(conn, :update, post_primary_certificate), post_primary_certificate: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(PostPrimaryCertificate, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    post_primary_certificate = Repo.insert! %PostPrimaryCertificate{}
    conn = put conn, post_primary_certificate_path(conn, :update, post_primary_certificate), post_primary_certificate: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    post_primary_certificate = Repo.insert! %PostPrimaryCertificate{}
    conn = delete conn, post_primary_certificate_path(conn, :delete, post_primary_certificate)
    assert response(conn, 204)
    refute Repo.get(PostPrimaryCertificate, post_primary_certificate.id)
  end
end
