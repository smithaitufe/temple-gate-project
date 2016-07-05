defmodule PortalApi.V1.StaffAcademicQualificationControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StaffAcademicQualification
  @valid_attrs %{course_studied: "some content", from: 42, school: "some content", to: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, staff_academic_qualification_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    staff_academic_qualification = Repo.insert! %StaffAcademicQualification{}
    conn = get conn, staff_academic_qualification_path(conn, :show, staff_academic_qualification)
    assert json_response(conn, 200)["data"] == %{"id" => staff_academic_qualification.id,
      "staff_id" => staff_academic_qualification.staff_id,
      "certificate_id" => staff_academic_qualification.certificate_id,
      "school" => staff_academic_qualification.school,
      "course_studied" => staff_academic_qualification.course_studied,
      "from" => staff_academic_qualification.from,
      "to" => staff_academic_qualification.to}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, staff_academic_qualification_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, staff_academic_qualification_path(conn, :create), staff_academic_qualification: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StaffAcademicQualification, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, staff_academic_qualification_path(conn, :create), staff_academic_qualification: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    staff_academic_qualification = Repo.insert! %StaffAcademicQualification{}
    conn = put conn, staff_academic_qualification_path(conn, :update, staff_academic_qualification), staff_academic_qualification: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StaffAcademicQualification, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    staff_academic_qualification = Repo.insert! %StaffAcademicQualification{}
    conn = put conn, staff_academic_qualification_path(conn, :update, staff_academic_qualification), staff_academic_qualification: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    staff_academic_qualification = Repo.insert! %StaffAcademicQualification{}
    conn = delete conn, staff_academic_qualification_path(conn, :delete, staff_academic_qualification)
    assert response(conn, 204)
    refute Repo.get(StaffAcademicQualification, staff_academic_qualification.id)
  end
end
