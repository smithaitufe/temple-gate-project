defmodule PortalApi.V1.CourseEnrollmentAssessmentControllerTest do
  use PortalApi.ConnCase

  alias PortalApi.V1.CourseEnrollmentAssessment
  @valid_attrs %{score: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, course_enrollment_assessment_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    course_enrollment_assessment = Repo.insert! %CourseEnrollmentAssessment{}
    conn = get conn, course_enrollment_assessment_path(conn, :show, course_enrollment_assessment)
    assert json_response(conn, 200)["data"] == %{"id" => course_enrollment_assessment.id,
      "assessment_type_id" => course_enrollment_assessment.assessment_type_id,
      "assessed_by_user_id" => course_enrollment_assessment.assessed_by_user_id,
      "course_enrollment_id" => course_enrollment_assessment.course_enrollment_id,
      "score" => course_enrollment_assessment.score}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, course_enrollment_assessment_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, course_enrollment_assessment_path(conn, :create), course_enrollment_assessment: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(CourseEnrollmentAssessment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, course_enrollment_assessment_path(conn, :create), course_enrollment_assessment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    course_enrollment_assessment = Repo.insert! %CourseEnrollmentAssessment{}
    conn = put conn, course_enrollment_assessment_path(conn, :update, course_enrollment_assessment), course_enrollment_assessment: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(CourseEnrollmentAssessment, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    course_enrollment_assessment = Repo.insert! %CourseEnrollmentAssessment{}
    conn = put conn, course_enrollment_assessment_path(conn, :update, course_enrollment_assessment), course_enrollment_assessment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    course_enrollment_assessment = Repo.insert! %CourseEnrollmentAssessment{}
    conn = delete conn, course_enrollment_assessment_path(conn, :delete, course_enrollment_assessment)
    assert response(conn, 204)
    refute Repo.get(CourseEnrollmentAssessment, course_enrollment_assessment.id)
  end
end
