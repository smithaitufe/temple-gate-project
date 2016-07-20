defmodule PortalApi.V1.StudentDiplomaQualificationControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StudentDiplomaQualification
  @valid_attrs %{cgpa: "120.5", course: "some content", school: "some content", year_graduated: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_diploma_qualification_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    student_diploma_qualification = Repo.insert! %StudentDiplomaQualification{}
    conn = get conn, student_diploma_qualification_path(conn, :show, student_diploma_qualification)
    assert json_response(conn, 200)["data"] == %{"id" => student_diploma_qualification.id,
      "student_id" => student_diploma_qualification.student_id,
      "school" => student_diploma_qualification.school,
      "course" => student_diploma_qualification.course,
      "cgpa" => student_diploma_qualification.cgpa,
      "year_graduated" => student_diploma_qualification.year_graduated}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, student_diploma_qualification_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, student_diploma_qualification_path(conn, :create), student_diploma_qualification: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StudentDiplomaQualification, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_diploma_qualification_path(conn, :create), student_diploma_qualification: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    student_diploma_qualification = Repo.insert! %StudentDiplomaQualification{}
    conn = put conn, student_diploma_qualification_path(conn, :update, student_diploma_qualification), student_diploma_qualification: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StudentDiplomaQualification, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    student_diploma_qualification = Repo.insert! %StudentDiplomaQualification{}
    conn = put conn, student_diploma_qualification_path(conn, :update, student_diploma_qualification), student_diploma_qualification: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    student_diploma_qualification = Repo.insert! %StudentDiplomaQualification{}
    conn = delete conn, student_diploma_qualification_path(conn, :delete, student_diploma_qualification)
    assert response(conn, 204)
    refute Repo.get(StudentDiplomaQualification, student_diploma_qualification.id)
  end
end
