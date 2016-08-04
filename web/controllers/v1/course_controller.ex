defmodule PortalApi.V1.CourseController do
  use PortalApi.Web, :controller

  alias PortalApi.{Course, Department}

  plug :scrub_params, "course" when action in [:create, :update]

  def index(conn, params) do
    courses = Course
    |> build_course_query(Map.to_list(params))
    |> Repo.all
    |> Repo.preload([:semester, :level, {:department, [:faculty, :department_type]}])

    render(conn, "index.json", courses: courses)
  end

  def create(conn, %{"course" => course_params}) do
    changeset = Course.changeset(%Course{}, course_params)

    case Repo.insert(changeset) do
      {:ok, course} ->
        course = Repo.preload(course, [:semester, :level, :department])

        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_course_path(conn, :show, course))
        |> render("show.json", course: course)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    course = Repo.get!(Course, id)
    |> Repo.preload([:semester, :level, :department])

    render(conn, "show.json", course: course)
  end

  def update(conn, %{"id" => id, "course" => course_params}) do
    course = Repo.get!(Course, id)
    changeset = Course.changeset(course, course_params)
    case Repo.update(changeset) do
      {:ok, course} ->
        course = Repo.preload(course, [:semester, :level, :department])
        render(conn, "show.json", course: course)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    course = Repo.get!(Course, id)
    Repo.delete!(course)
    send_resp(conn, :no_content, "")
  end


  def get_courses_by_department_and_level(conn, %{"department_id" => department_id, "level_id" => level_id}) do
    query = from c in Course,
            where: c.department_id == ^department_id and c.level_id == ^level_id

    courses = query
    |> Course.load_associations
    |> Repo.all

    render(conn, "index.json", courses: courses)
  end

  defp build_course_query(query, []),  do: query
  defp build_course_query(query, [{"department_id", value} | tail]) do
    query
    |> Ecto.Query.where([c], c.department_id == ^value)
    |> build_course_query(tail)
  end
  defp build_course_query(query, [{"level_id", value} | tail])  do
    query
    |> Ecto.Query.where([c], c.level_id == ^value)
    |> build_course_query(tail)
  end
  defp build_course_query(query, [{"semester_id", value} | tail])  do
    query
    |> Ecto.Query.where([c], c.semester_id == ^value)
    |> build_course_query(tail)
  end
  defp build_course_query(query, [{"student_id", student_id} | tail]) do
    query
    |> Ecto.Query.join(:inner, [c], sc in assoc(c, :student_courses))
    |> Ecto.Query.join(:inner, [c, sc], s in assoc(sc, :student))
    |> Ecto.Query.where([_, sc, _], sc.student_id == ^student_id)
    |> build_course_query(tail)
  end
  defp build_course_query(query, [{"order_by", field} | tail]) do
    query
    |> Ecto.Query.order_by([asc: ^String.to_existing_atom(field)])
    |> build_course_query(tail)
  end
  defp build_course_query(query, [{"order_by_desc", field} | tail]) do
    query
    |> Ecto.Query.order_by([desc: ^String.to_existing_atom(field)])
    |> build_course_query(tail)
  end


end
