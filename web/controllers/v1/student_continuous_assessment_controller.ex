defmodule PortalApi.V1.StudentContinuousAssessmentController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentContinuousAssessment

  plug :scrub_params, "student_continuous_assessment" when action in [:create, :update]

  def index(conn, _params) do
    student_continuous_assessments = Repo.all(StudentContinuousAssessment)
    render(conn, "index.json", student_continuous_assessments: student_continuous_assessments)
  end

  def create(conn, %{"student_continuous_assessment" => student_continuous_assessment_params}) do
    changeset = StudentContinuousAssessment.changeset(%StudentContinuousAssessment{}, student_continuous_assessment_params)

    case Repo.insert(changeset) do
      {:ok, student_continuous_assessment} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_continuous_assessment_path(conn, :show, student_continuous_assessment))
        |> render("show.json", student_continuous_assessment: student_continuous_assessment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student_continuous_assessment = Repo.get!(StudentContinuousAssessment, id)
    render(conn, "show.json", student_continuous_assessment: student_continuous_assessment)
  end

  def update(conn, %{"id" => id, "student_continuous_assessment" => student_continuous_assessment_params}) do
    student_continuous_assessment = Repo.get!(StudentContinuousAssessment, id)
    changeset = StudentContinuousAssessment.changeset(student_continuous_assessment, student_continuous_assessment_params)

    case Repo.update(changeset) do
      {:ok, student_continuous_assessment} ->
        render(conn, "show.json", student_continuous_assessment: student_continuous_assessment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student_continuous_assessment = Repo.get!(StudentContinuousAssessment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_continuous_assessment)

    send_resp(conn, :no_content, "")
  end
end
