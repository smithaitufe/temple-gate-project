defmodule PortalApi.V1.PostSecondaryCertificateControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.PostSecondaryCertificate
  @valid_attrs %{cgpa: "120.5", course_studied: "some content", school: "some content", verified: true, verified_at: "2010-04-17 14:00:00", year_admitted: 42, year_graduated: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_secondary_certificate_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    post_secondary_certificate = Repo.insert! %PostSecondaryCertificate{}
    conn = get conn, post_secondary_certificate_path(conn, :show, post_secondary_certificate)
    assert json_response(conn, 200)["data"] == %{"id" => post_secondary_certificate.id,
      "student_id" => post_secondary_certificate.student_id,
      "school" => post_secondary_certificate.school,
      "course_studied" => post_secondary_certificate.course_studied,
      "cgpa" => post_secondary_certificate.cgpa,
      "year_admitted" => post_secondary_certificate.year_admitted,
      "year_graduated" => post_secondary_certificate.year_graduated,
      "verified" => post_secondary_certificate.verified,
      "verified_by_staff_id" => post_secondary_certificate.verified_by_staff_id,
      "verified_at" => post_secondary_certificate.verified_at}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, post_secondary_certificate_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, post_secondary_certificate_path(conn, :create), post_secondary_certificate: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(PostSecondaryCertificate, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, post_secondary_certificate_path(conn, :create), post_secondary_certificate: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    post_secondary_certificate = Repo.insert! %PostSecondaryCertificate{}
    conn = put conn, post_secondary_certificate_path(conn, :update, post_secondary_certificate), post_secondary_certificate: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(PostSecondaryCertificate, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    post_secondary_certificate = Repo.insert! %PostSecondaryCertificate{}
    conn = put conn, post_secondary_certificate_path(conn, :update, post_secondary_certificate), post_secondary_certificate: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    post_secondary_certificate = Repo.insert! %PostSecondaryCertificate{}
    conn = delete conn, post_secondary_certificate_path(conn, :delete, post_secondary_certificate)
    assert response(conn, 204)
    refute Repo.get(PostSecondaryCertificate, post_secondary_certificate.id)
  end
end
