defmodule PortalApi.V1.StudentCertificateControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StudentCertificate
  @valid_attrs %{registration_no: "some content", year_obtained: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_certificate_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    student_certificate = Repo.insert! %StudentCertificate{}
    conn = get conn, student_certificate_path(conn, :show, student_certificate)
    assert json_response(conn, 200)["data"] == %{"id" => student_certificate.id,
      "student_id" => student_certificate.student_id,
      "examination_body_id" => student_certificate.examination_body_id,
      "year_obtained" => student_certificate.year_obtained,
      "registration_no" => student_certificate.registration_no}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, student_certificate_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, student_certificate_path(conn, :create), student_certificate: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StudentCertificate, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_certificate_path(conn, :create), student_certificate: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    student_certificate = Repo.insert! %StudentCertificate{}
    conn = put conn, student_certificate_path(conn, :update, student_certificate), student_certificate: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StudentCertificate, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    student_certificate = Repo.insert! %StudentCertificate{}
    conn = put conn, student_certificate_path(conn, :update, student_certificate), student_certificate: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    student_certificate = Repo.insert! %StudentCertificate{}
    conn = delete conn, student_certificate_path(conn, :delete, student_certificate)
    assert response(conn, 204)
    refute Repo.get(StudentCertificate, student_certificate.id)
  end
end
