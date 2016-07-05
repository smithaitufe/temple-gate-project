defmodule PortalApi.V1.StudentResultGradeController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentResultGrade

  plug :scrub_params, "student_result_grade" when action in [:create, :update]

  def index(conn, _params) do
    student_result_grades = Repo.all(StudentResultGrade)
    render(conn, "index.json", student_result_grades: student_result_grades)
  end

  def create(conn, %{"student_result_grade" => student_result_grade_params}) do
    changeset = StudentResultGrade.changeset(%StudentResultGrade{}, student_result_grade_params)

    case Repo.insert(changeset) do
      {:ok, student_result_grade} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_result_grade_path(conn, :show, student_result_grade))
        |> render("show.json", student_result_grade: student_result_grade)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student_result_grade = Repo.get!(StudentResultGrade, id)
    render(conn, "show.json", student_result_grade: student_result_grade)
  end

  def update(conn, %{"id" => id, "student_result_grade" => student_result_grade_params}) do
    student_result_grade = Repo.get!(StudentResultGrade, id)
    changeset = StudentResultGrade.changeset(student_result_grade, student_result_grade_params)

    case Repo.update(changeset) do
      {:ok, student_result_grade} ->
        render(conn, "show.json", student_result_grade: student_result_grade)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student_result_grade = Repo.get!(StudentResultGrade, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_result_grade)

    send_resp(conn, :no_content, "")
  end
end
