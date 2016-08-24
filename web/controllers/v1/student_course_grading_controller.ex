defmodule PortalApi.V1.StudentCourseGradingController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentCourseGrading

  plug :scrub_params, "student_course_grading" when action in [:create, :update]

  def index(conn, params) do
    student_course_gradings = StudentCourseGrading
    |> Ecto.Query.join(:left, [cg], sc in assoc(cg, :student_course))
    |> Ecto.Query.join(:left, [cg, sc, c], c in assoc(sc, :course))
    |> build_query(Map.to_list(params))
    |> Repo.all

    render(conn, "index.json", student_course_gradings: student_course_gradings)
  end

  def create(conn, %{"student_course_grading" => student_course_grading_params}) do
    changeset = StudentCourseGrading.changeset(%StudentCourseGrading{}, student_course_grading_params)

    case Repo.insert(changeset) do
      {:ok, student_course_grading} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_course_grading_path(conn, :show, student_course_grading))
        |> render("show.json", student_course_grading: student_course_grading)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student_course_grading = Repo.get!(StudentCourseGrading, id)
    render(conn, "show.json", student_course_grading: student_course_grading)
  end

  def update(conn, %{"id" => id, "student_course_grading" => student_course_grading_params}) do
    student_course_grading = Repo.get!(StudentCourseGrading, id)
    changeset = StudentCourseGrading.changeset(student_course_grading, student_course_grading_params)

    case Repo.update(changeset) do
      {:ok, student_course_grading} ->
        render(conn, "show.json", student_course_grading: student_course_grading)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student_course_grading = Repo.get!(StudentCourseGrading, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_course_grading)

    send_resp(conn, :no_content, "")
  end

  defp build_query(query, []), do: query
  defp build_query(query, [{"level_id", level_id} | tail]) do
    query
    |> Ecto.Query.where([_, _, c], c.level_id == ^level_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"academic_session_id", academic_session_id} | tail]) do
    query
    |> Ecto.Query.where([_, sc, c], sc.academic_session_id == ^academic_session_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"student_id", student_id} | tail]) do
    query
    |> Ecto.Query.where([_, sc, c], sc.student_id == ^student_id)
    |> build_query(tail)
  end
end
