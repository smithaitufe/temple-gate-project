defmodule PortalApi.V1.DiplomaQualificationControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.DiplomaQualification
  @valid_attrs %{cgpa: "120.5", course: "some content", school: "some content", year_graduated: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, diploma_qualification_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    diploma_qualification = Repo.insert! %DiplomaQualification{}
    conn = get conn, diploma_qualification_path(conn, :show, diploma_qualification)
    assert json_response(conn, 200)["data"] == %{"id" => diploma_qualification.id,
      "student_id" => diploma_qualification.student_id,
      "school" => diploma_qualification.school,
      "course" => diploma_qualification.course,
      "cgpa" => diploma_qualification.cgpa,
      "year_graduated" => diploma_qualification.year_graduated}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, diploma_qualification_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, diploma_qualification_path(conn, :create), diploma_qualification: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(DiplomaQualification, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, diploma_qualification_path(conn, :create), diploma_qualification: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    diploma_qualification = Repo.insert! %DiplomaQualification{}
    conn = put conn, diploma_qualification_path(conn, :update, diploma_qualification), diploma_qualification: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(DiplomaQualification, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    diploma_qualification = Repo.insert! %DiplomaQualification{}
    conn = put conn, diploma_qualification_path(conn, :update, diploma_qualification), diploma_qualification: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    diploma_qualification = Repo.insert! %DiplomaQualification{}
    conn = delete conn, diploma_qualification_path(conn, :delete, diploma_qualification)
    assert response(conn, 204)
    refute Repo.get(DiplomaQualification, diploma_qualification.id)
  end
end
