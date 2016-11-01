defmodule PortalApi.V1.AcademicQualificationControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.AcademicQualification
  @valid_attrs %{course_studied: "some content", from: 42, school: "some content", to: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, academic_qualification_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    academic_qualification = Repo.insert! %AcademicQualification{}
    conn = get conn, academic_qualification_path(conn, :show, academic_qualification)
    assert json_response(conn, 200)["data"] == %{"id" => academic_qualification.id,
      "user_id" => academic_qualification.user_id,
      "certificate_type_id" => academic_qualification.certificate_type_id,
      "school" => academic_qualification.school,
      "course_studied" => academic_qualification.course_studied,
      "from" => academic_qualification.from,
      "to" => academic_qualification.to}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, academic_qualification_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, academic_qualification_path(conn, :create), academic_qualification: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(AcademicQualification, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, academic_qualification_path(conn, :create), academic_qualification: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    academic_qualification = Repo.insert! %AcademicQualification{}
    conn = put conn, academic_qualification_path(conn, :update, academic_qualification), academic_qualification: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(AcademicQualification, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    academic_qualification = Repo.insert! %AcademicQualification{}
    conn = put conn, academic_qualification_path(conn, :update, academic_qualification), academic_qualification: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    academic_qualification = Repo.insert! %AcademicQualification{}
    conn = delete conn, academic_qualification_path(conn, :delete, academic_qualification)
    assert response(conn, 204)
    refute Repo.get(AcademicQualification, academic_qualification.id)
  end
end
