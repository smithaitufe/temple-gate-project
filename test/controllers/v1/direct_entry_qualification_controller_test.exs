defmodule PortalApi.V1.DirectEntryQualificationControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.DirectEntryQualification
  @valid_attrs %{cgpa: "120.5", course_studied: "some content", school: "some content", verified: true, verified_at: "2010-04-17 14:00:00", year_admitted: 42, year_graduated: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, direct_entry_qualification_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    direct_entry_qualification = Repo.insert! %DirectEntryQualification{}
    conn = get conn, direct_entry_qualification_path(conn, :show, direct_entry_qualification)
    assert json_response(conn, 200)["data"] == %{"id" => direct_entry_qualification.id,
      "student_id" => direct_entry_qualification.student_id,
      "school" => direct_entry_qualification.school,
      "course_studied" => direct_entry_qualification.course_studied,
      "cgpa" => direct_entry_qualification.cgpa,
      "year_admitted" => direct_entry_qualification.year_admitted,
      "year_graduated" => direct_entry_qualification.year_graduated,
      "verified" => direct_entry_qualification.verified,
      "verified_by_staff_id" => direct_entry_qualification.verified_by_staff_id,
      "verified_at" => direct_entry_qualification.verified_at}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, direct_entry_qualification_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, direct_entry_qualification_path(conn, :create), direct_entry_qualification: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(DirectEntryQualification, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, direct_entry_qualification_path(conn, :create), direct_entry_qualification: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    direct_entry_qualification = Repo.insert! %DirectEntryQualification{}
    conn = put conn, direct_entry_qualification_path(conn, :update, direct_entry_qualification), direct_entry_qualification: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(DirectEntryQualification, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    direct_entry_qualification = Repo.insert! %DirectEntryQualification{}
    conn = put conn, direct_entry_qualification_path(conn, :update, direct_entry_qualification), direct_entry_qualification: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    direct_entry_qualification = Repo.insert! %DirectEntryQualification{}
    conn = delete conn, direct_entry_qualification_path(conn, :delete, direct_entry_qualification)
    assert response(conn, 204)
    refute Repo.get(DirectEntryQualification, direct_entry_qualification.id)
  end
end
