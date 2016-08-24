defmodule PortalApi.V1.StudentAssessmentControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StudentAssessment
  @valid_attrs %{score: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_assessment_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    student_assessment = Repo.insert! %StudentAssessment{}
    conn = get conn, student_assessment_path(conn, :show, student_assessment)
    assert json_response(conn, 200)["data"] == %{"id" => student_assessment.id,
      "course_id" => student_assessment.course_id,
      "staff_id" => student_assessment.staff_id,
      "student_id" => student_assessment.student_id,
      "score" => student_assessment.score}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, student_assessment_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, student_assessment_path(conn, :create), student_assessment: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StudentAssessment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_assessment_path(conn, :create), student_assessment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    student_assessment = Repo.insert! %StudentAssessment{}
    conn = put conn, student_assessment_path(conn, :update, student_assessment), student_assessment: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StudentAssessment, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    student_assessment = Repo.insert! %StudentAssessment{}
    conn = put conn, student_assessment_path(conn, :update, student_assessment), student_assessment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    student_assessment = Repo.insert! %StudentAssessment{}
    conn = delete conn, student_assessment_path(conn, :delete, student_assessment)
    assert response(conn, 204)
    refute Repo.get(StudentAssessment, student_assessment.id)
  end
end
