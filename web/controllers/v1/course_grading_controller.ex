defmodule PortalApi.V1.CourseGradingController do
  use PortalApi.Web, :controller

  alias PortalApi.CourseGrading

  plug :scrub_params, "course_grading" when action in [:create, :update]

  def index(conn, params) do
    course_gradings = CourseGrading
    |> Ecto.Query.join(:left, [cg], ce in assoc(cg, :course_enrollment))
    |> Ecto.Query.join(:left, [cg, ce, c], c in assoc(ce, :course))
    |> build_query(Map.to_list(params))
    |> Repo.all

    render(conn, "index.json", course_gradings: course_gradings)
  end

  def create(conn, %{"course_grading" => course_grading_params}) do
    changeset = CourseGrading.changeset(%CourseGrading{}, course_grading_params)

    case Repo.insert(changeset) do
      {:ok, course_grading} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_course_grading_path(conn, :show, course_grading))
        |> render("show.json", course_grading: course_grading)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    course_grading = Repo.get!(CourseGrading, id)
    render(conn, "show.json", course_grading: course_grading)
  end

  def update(conn, %{"id" => id, "course_grading" => course_grading_params}) do
    course_grading = Repo.get!(CourseGrading, id)
    changeset = CourseGrading.changeset(course_grading, course_grading_params)

    case Repo.update(changeset) do
      {:ok, course_grading} ->
        render(conn, "show.json", course_grading: course_grading)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    course_grading = Repo.get!(CourseGrading, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(course_grading)

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
    |> Ecto.Query.where([_, ce, c], ce.academic_session_id == ^academic_session_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"student_id", student_id} | tail]) do
    query
    |> Ecto.Query.where([_, ce, c], ce.student_id == ^student_id)
    |> build_query(tail)
  end
end
