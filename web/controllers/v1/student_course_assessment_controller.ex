defmodule PortalApi.V1.StudentCourseAssessmentController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentCourseAssessment

  plug :scrub_params, "student_course_assessment" when action in [:create, :update]

  def index(conn, _params) do
    student_course_assessments = Repo.all(StudentCourseAssessment)
    |> Repo.preload(StudentCourseAssessment.associations)
    render(conn, "index.json", student_course_assessments: student_course_assessments)
  end

  def create(conn, %{"student_course_assessment" => student_course_assessment_params}) do
    changeset = StudentCourseAssessment.changeset(%StudentCourseAssessment{}, student_course_assessment_params)

    case Repo.insert(changeset) do
      {:ok, student_course_assessment} ->
        student_course_assessment = student_course_assessment |> Repo.preload(StudentCourseAssessment.associations)
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_course_assessment_path(conn, :show, student_course_assessment))
        |> render("show.json", student_course_assessment: student_course_assessment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student_course_assessment = Repo.get!(StudentCourseAssessment, id)
    |> Repo.preload(StudentCourseAssessment.associations)
    render(conn, "show.json", student_course_assessment: student_course_assessment)
  end

  def update(conn, %{"id" => id, "student_course_assessment" => student_course_assessment_params}) do
    student_course_assessment = Repo.get!(StudentCourseAssessment, id)
    changeset = StudentCourseAssessment.changeset(student_course_assessment, student_course_assessment_params)

    case Repo.update(changeset) do
      {:ok, student_course_assessment} ->
        student_course_assessment = student_course_assessment |> Repo.preload(StudentCourseAssessment.associations)
        render(conn, "show.json", student_course_assessment: student_course_assessment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student_course_assessment = Repo.get!(StudentCourseAssessment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_course_assessment)

    send_resp(conn, :no_content, "")
  end
end
