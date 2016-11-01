defmodule PortalApi.V1.CourseEnrollmentAssessmentController do
  use PortalApi.Web, :controller

  alias PortalApi.CourseEnrollmentAssessment

  plug :scrub_params, "course_enrollment_assessment" when action in [:create, :update]

  def index(conn, _params) do
    course_enrollment_assessments = Repo.all(CourseEnrollmentAssessment)
    |> Repo.preload(CourseEnrollmentAssessment.associations)
    render(conn, "index.json", course_enrollment_assessments: course_enrollment_assessments)
  end

  def create(conn, %{"course_enrollment_assessment" => course_enrollment_assessment_params}) do
    changeset = CourseEnrollmentAssessment.changeset(%CourseEnrollmentAssessment{}, course_enrollment_assessment_params)

    case Repo.insert(changeset) do
      {:ok, course_enrollment_assessment} ->
        course_enrollment_assessment = course_enrollment_assessment |> Repo.preload(CourseEnrollmentAssessment.associations)
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_course_enrollment_assessment_path(conn, :show, course_enrollment_assessment))
        |> render("show.json", course_enrollment_assessment: course_enrollment_assessment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    course_enrollment_assessment = Repo.get!(CourseEnrollmentAssessment, id)
    |> Repo.preload(CourseEnrollmentAssessment.associations)
    render(conn, "show.json", course_enrollment_assessment: course_enrollment_assessment)
  end

  def update(conn, %{"id" => id, "course_enrollment_assessment" => course_enrollment_assessment_params}) do
    course_enrollment_assessment = Repo.get!(CourseEnrollmentAssessment, id)
    changeset = CourseEnrollmentAssessment.changeset(course_enrollment_assessment, course_enrollment_assessment_params)

    case Repo.update(changeset) do
      {:ok, course_enrollment_assessment} ->
        course_enrollment_assessment = course_enrollment_assessment |> Repo.preload(CourseEnrollmentAssessment.associations)
        render(conn, "show.json", course_enrollment_assessment: course_enrollment_assessment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    course_enrollment_assessment = Repo.get!(CourseEnrollmentAssessment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(course_enrollment_assessment)

    send_resp(conn, :no_content, "")
  end
end
