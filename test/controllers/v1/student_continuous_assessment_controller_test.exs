defmodule PortalApi.V1.StudentContinuousAssessmentControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.StudentContinuousAssessment
  @valid_attrs %{score: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, student_continuous_assessment_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    student_continuous_assessment = Repo.insert! %StudentContinuousAssessment{}
    conn = get conn, student_continuous_assessment_path(conn, :show, student_continuous_assessment)
    assert json_response(conn, 200)["data"] == %{"id" => student_continuous_assessment.id,
      "course_id" => student_continuous_assessment.course_id,
      "staff_id" => student_continuous_assessment.staff_id,
      "student_id" => student_continuous_assessment.student_id,
      "score" => student_continuous_assessment.score}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, student_continuous_assessment_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, student_continuous_assessment_path(conn, :create), student_continuous_assessment: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(StudentContinuousAssessment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, student_continuous_assessment_path(conn, :create), student_continuous_assessment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    student_continuous_assessment = Repo.insert! %StudentContinuousAssessment{}
    conn = put conn, student_continuous_assessment_path(conn, :update, student_continuous_assessment), student_continuous_assessment: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(StudentContinuousAssessment, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    student_continuous_assessment = Repo.insert! %StudentContinuousAssessment{}
    conn = put conn, student_continuous_assessment_path(conn, :update, student_continuous_assessment), student_continuous_assessment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    student_continuous_assessment = Repo.insert! %StudentContinuousAssessment{}
    conn = delete conn, student_continuous_assessment_path(conn, :delete, student_continuous_assessment)
    assert response(conn, 204)
    refute Repo.get(StudentContinuousAssessment, student_continuous_assessment.id)
  end
end
