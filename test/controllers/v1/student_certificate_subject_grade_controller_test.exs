defmodule PortalApi.V1.StudentCertificateSubjectGradeControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StudentCertificateSubjectGrade
  @valid_attrs %{}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_certificate_subject_grade_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    student_certificate_subject_grade = Repo.insert! %StudentCertificateSubjectGrade{}
    conn = get conn, student_certificate_subject_grade_path(conn, :show, student_certificate_subject_grade)
    assert json_response(conn, 200)["data"] == %{"id" => student_certificate_subject_grade.id,
      "student_certificate_id" => student_certificate_subject_grade.student_certificate_id,
      "subject_id" => student_certificate_subject_grade.subject_id,
      "grade_id" => student_certificate_subject_grade.grade_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, student_certificate_subject_grade_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, student_certificate_subject_grade_path(conn, :create), student_certificate_subject_grade: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StudentCertificateSubjectGrade, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_certificate_subject_grade_path(conn, :create), student_certificate_subject_grade: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    student_certificate_subject_grade = Repo.insert! %StudentCertificateSubjectGrade{}
    conn = put conn, student_certificate_subject_grade_path(conn, :update, student_certificate_subject_grade), student_certificate_subject_grade: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StudentCertificateSubjectGrade, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    student_certificate_subject_grade = Repo.insert! %StudentCertificateSubjectGrade{}
    conn = put conn, student_certificate_subject_grade_path(conn, :update, student_certificate_subject_grade), student_certificate_subject_grade: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    student_certificate_subject_grade = Repo.insert! %StudentCertificateSubjectGrade{}
    conn = delete conn, student_certificate_subject_grade_path(conn, :delete, student_certificate_subject_grade)
    assert response(conn, 204)
    refute Repo.get(StudentCertificateSubjectGrade, student_certificate_subject_grade.id)
  end
end
