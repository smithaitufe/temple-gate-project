defmodule PortalApi.V1.StudentCourseController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentCourse

  plug :scrub_params, "student_course" when action in [:create, :update]

  def index(conn, params) do
    student_courses = StudentCourse
    |> Ecto.Query.join(:inner, [sc], a in assoc(sc, :academic_session))
    |> Ecto.Query.join(:inner, [sc, a], c in assoc(sc, :course))

    |> build_query(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(StudentCourse.associations)

    render(conn, "index.json", student_courses: student_courses)
  end

  def create(conn, %{"student_course" => student_course_params}) do
    changeset = StudentCourse.changeset(%StudentCourse{}, student_course_params)

    case Repo.insert(changeset) do
      {:ok, student_course} ->
        student_course = student_course |> Repo.preload(StudentCourse.associations)
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
    student_course = Repo.get!(StudentCourse, id) |> Repo.preload(StudentCourse.associations)

    render(conn, "show.json", student_course: student_course)
  end

  def update(conn, %{"id" => id, "student_course" => student_course_params}) do
    student_course = Repo.get!(StudentCourse, id)
    changeset = StudentCourse.changeset(student_course, student_course_params)
    case Repo.update(changeset) do
      {:ok, student_course} ->
        student_course = student_course |> Repo.preload(StudentCourse.associations)
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
    |> Ecto.Query.where([_, _, c], c.level_id == ^level_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"course_id", course_id} | tail]) do
    query
    |> Ecto.Query.where([sc, _, _], sc.course_id == ^course_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"academic_session_id", academic_session_id} | tail]) do
    query
    |> Ecto.Query.where([sc,_, _], sc.academic_session_id == ^academic_session_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"academic_session", academic_session} | tail]) do
    query
    |> Ecto.Query.where([_, a, _], a.description == ^academic_session)
    |> build_query(tail)
  end

  defp build_query(query, [{"student_id", student_id} | tail]) do
    query
    |> Ecto.Query.where([sc, _, _], sc.student_id == ^student_id)
    |> build_query(tail)
  end

end
