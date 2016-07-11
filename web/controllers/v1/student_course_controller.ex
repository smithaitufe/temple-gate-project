defmodule PortalApi.V1.StudentCourseController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentCourse

  plug :scrub_params, "student_course" when action in [:create, :update]

  def index(conn, _params) do
    student_courses = StudentCourse
    |> StudentCourse.load_associations
    |> Repo.all

    render(conn, "index.json", student_courses: student_courses)
  end

  def create(conn, %{"student_course" => student_course_params}) do
    changeset = StudentCourse.changeset(%StudentCourse{}, student_course_params)

    case Repo.insert(changeset) do
      {:ok, student_course} ->
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
    student_course = Repo.get!(StudentCourse, id)
    render(conn, "show.json", student_course: student_course)
  end

  def update(conn, %{"id" => id, "student_course" => student_course_params}) do
    student_course = Repo.get!(StudentCourse, id)
    changeset = StudentCourse.changeset(student_course, student_course_params)

    case Repo.update(changeset) do
      {:ok, student_course} ->
        render(conn, "show.json", student_course: student_course)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student_course = Repo.get!(StudentCourse, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_course)

    send_resp(conn, :no_content, "")
  end

  def get_student_courses_by_level(conn, %{"student_id" => student_id, "level_id" => level_id}) do
    student_courses = StudentCourse
    |> StudentCourse.load_associations
    |> StudentCourse.get_student_courses_by_level(student_id, level_id)
    |> Repo.all

    render(conn, "index.json", student_courses: student_courses)

  end
end
