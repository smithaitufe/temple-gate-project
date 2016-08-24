defmodule PortalApi.V1.StudentCourseController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentCourse

  plug :scrub_params, "student_course" when action in [:create, :update]

  def index(conn, params) do
    student_courses = StudentCourse
    |> build_query(Map.to_list(params))
    |> Repo.all
    |> preload_models
    render(conn, "index.json", student_courses: student_courses)
  end

  def create(conn, %{"student_course" => student_course_params}) do
    changeset = StudentCourse.changeset(%StudentCourse{}, student_course_params)

    case Repo.insert(changeset) do
      {:ok, student_course} ->
        student_course = preload_models(student_course)
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_course_path(conn, :show, student_course))
        |> render("show.json", student_course: student_course)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end

  end

  def show(conn, %{"id" => id}) do
    student_course = Repo.get!(StudentCourse, id) |> preload_models

    render(conn, "show.json", student_course: student_course)
  end

  def update(conn, %{"id" => id, "student_course" => student_course_params}) do
    student_course = Repo.get!(StudentCourse, id)
    changeset = StudentCourse.changeset(student_course, student_course_params)
    case Repo.update(changeset) do
      {:ok, student_course} ->
        student_course = preload_models(student_course)
        render(conn, "show.json", student_course: student_course)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"student_id" => student_id, "id" => id}) do
    student_course = Repo.get_by!(StudentCourse, [student_id: student_id, id: id])

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_course)

    send_resp(conn, :no_content, "")
  end
  defp build_query(query, []), do: query
  defp build_query(query, [{"level_id", level_id} | tail]) do
    query
    |> Ecto.Query.join(:left, [sc], c in assoc(sc, :course))
    |> Ecto.Query.where([_, c], c.level_id == ^level_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"course_id", course_id} | tail]) do
    query
    |> Ecto.Query.where([sc], sc.course_id == ^course_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"academic_session_id", academic_session_id} | tail]) do
    query
    |> Ecto.Query.where([sc], sc.academic_session_id == ^academic_session_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"student_id", student_id} | tail]) do
    query
    |> Ecto.Query.where([sc], sc.student_id == ^student_id)
    |> build_query(tail)
  end
  defp preload_models(model) do
     Repo.preload(model, [{:student,[:gender, :marital_status, {:program, [:levels]}, :level, {:department, [:faculty, :department_type]}]}, :academic_session, {:course, [{:department, [:faculty, :department_type]}, :level, :semester]}, :course_grading])
  end
end
