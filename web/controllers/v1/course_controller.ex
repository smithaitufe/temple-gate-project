defmodule PortalApi.V1.CourseController do
  use PortalApi.Web, :controller

  alias PortalApi.{Course, Department}

  plug :scrub_params, "course" when action in [:create, :update]

  def index(conn, params) do
    courses = Course
    |> build_query(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(Course.associations)

    render(conn, "index.json", courses: courses)
  end

  def create(conn, %{"course" => course_params}) do
    changeset = Course.changeset(%Course{}, course_params)

    case Repo.insert(changeset) do
      {:ok, course} ->
        course = Repo.preload(course, Course.associations)

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
    |> Repo.preload(Course.associations)

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


  defp build_query(query, []),  do: query
  # defp build_query(query, [{"program_id", program_id} | tail]) do
  #   query
  #   |> Ecto.Query.where([c], c.program_id == ^program_id)
  #   |> build_query(tail)
  # end
defp build_query(query, [{"department_id", value} | tail]) do
    query
    |> Ecto.Query.where([c], c.department_id == ^value)
    |> build_query(tail)
  end
  defp build_query(query, [{"level_id", value} | tail])  do
    query
    |> Ecto.Query.where([c], c.level_id == ^value)
    |> build_query(tail)
  end
  defp build_query(query, [{"semester_id", value} | tail])  do
    query
    |> Ecto.Query.where([c], c.semester_id == ^value)
    |> build_query(tail)
  end
  defp build_query(query, [{"core", core} | tail]) do
    query
    |> Ecto.Query.where([c], c.core == ^core)
    |> build_query(tail)
  end
  defp build_query(query, [{"order_by", field} | tail]) do
    query
    |> Ecto.Query.order_by([asc: ^String.to_existing_atom(field)])
    |> build_query(tail)
  end
  defp build_query(query, [{"order_by_desc", field} | tail]) do
    query
    |> Ecto.Query.order_by([desc: ^String.to_existing_atom(field)])
    |> build_query(tail)
  end


end
