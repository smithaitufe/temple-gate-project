defmodule PortalApi.V1.StudentAssessmentController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentAssessment

  plug :scrub_params, "student_assessment" when action in [:create, :update]

  def index(conn, _params) do
    student_assessments = Repo.all(StudentAssessment)
    render(conn, "index.json", student_assessments: student_assessments)
  end

  def create(conn, %{"student_assessment" => student_assessment_params}) do
    changeset = StudentAssessment.changeset(%StudentAssessment{}, student_assessment_params)

    case Repo.insert(changeset) do
      {:ok, student_assessment} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_assessment_path(conn, :show, student_assessment))
        |> render("show.json", student_assessment: student_assessment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student_assessment = Repo.get!(StudentAssessment, id)
    render(conn, "show.json", student_assessment: student_assessment)
  end

  def update(conn, %{"id" => id, "student_assessment" => student_assessment_params}) do
    student_assessment = Repo.get!(StudentAssessment, id)
    changeset = StudentAssessment.changeset(student_assessment, student_assessment_params)

    case Repo.update(changeset) do
      {:ok, student_assessment} ->
        render(conn, "show.json", student_assessment: student_assessment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student_assessment = Repo.get!(StudentAssessment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_assessment)

    send_resp(conn, :no_content, "")
  end
end
