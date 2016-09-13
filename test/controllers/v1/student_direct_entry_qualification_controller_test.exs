defmodule PortalApi.V1.StudentDirectEntryQualificationControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StudentDirectEntryQualification
  @valid_attrs %{cgpa: "120.5", course_studied: "some content", school: "some content", verified: true, verified_at: "2010-04-17 14:00:00", year_admitted: 42, year_graduated: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_direct_entry_qualification_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    student_direct_entry_qualification = Repo.insert! %StudentDirectEntryQualification{}
    conn = get conn, student_direct_entry_qualification_path(conn, :show, student_direct_entry_qualification)
    assert json_response(conn, 200)["data"] == %{"id" => student_direct_entry_qualification.id,
      "student_id" => student_direct_entry_qualification.student_id,
      "school" => student_direct_entry_qualification.school,
      "course_studied" => student_direct_entry_qualification.course_studied,
      "cgpa" => student_direct_entry_qualification.cgpa,
      "year_admitted" => student_direct_entry_qualification.year_admitted,
      "year_graduated" => student_direct_entry_qualification.year_graduated,
      "verified" => student_direct_entry_qualification.verified,
      "verified_by_staff_id" => student_direct_entry_qualification.verified_by_staff_id,
      "verified_at" => student_direct_entry_qualification.verified_at}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, student_direct_entry_qualification_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, student_direct_entry_qualification_path(conn, :create), student_direct_entry_qualification: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StudentDirectEntryQualification, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_direct_entry_qualification_path(conn, :create), student_direct_entry_qualification: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    student_direct_entry_qualification = Repo.insert! %StudentDirectEntryQualification{}
    conn = put conn, student_direct_entry_qualification_path(conn, :update, student_direct_entry_qualification), student_direct_entry_qualification: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StudentDirectEntryQualification, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    student_direct_entry_qualification = Repo.insert! %StudentDirectEntryQualification{}
    conn = put conn, student_direct_entry_qualification_path(conn, :update, student_direct_entry_qualification), student_direct_entry_qualification: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    student_direct_entry_qualification = Repo.insert! %StudentDirectEntryQualification{}
    conn = delete conn, student_direct_entry_qualification_path(conn, :delete, student_direct_entry_qualification)
    assert response(conn, 204)
    refute Repo.get(StudentDirectEntryQualification, student_direct_entry_qualification.id)
  end
end
