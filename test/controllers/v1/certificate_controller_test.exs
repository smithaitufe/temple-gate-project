defmodule PortalApi.V1.CertificateControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.Certificate
  @valid_attrs %{user_id: 12, registration_no: "some content", year_obtained: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, certificate_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    certificate = Repo.insert! %Certificate{}
    conn = get conn, certificate_path(conn, :show, certificate)
    assert json_response(conn, 200)["data"] == %{"id" => certificate.id,
      "student_id" => certificate.student_id,
      "examination_body_id" => certificate.examination_body_id,
      "year_obtained" => certificate.year_obtained,
      "registration_no" => certificate.registration_no}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, certificate_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, certificate_path(conn, :create), certificate: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Certificate, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, certificate_path(conn, :create), certificate: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    certificate = Repo.insert! %Certificate{}
    conn = put conn, certificate_path(conn, :update, certificate), certificate: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Certificate, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    certificate = Repo.insert! %Certificate{}
    conn = put conn, certificate_path(conn, :update, certificate), certificate: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    certificate = Repo.insert! %Certificate{}
    conn = delete conn, certificate_path(conn, :delete, certificate)
    assert response(conn, 204)
    refute Repo.get(Certificate, certificate.id)
  end
end
