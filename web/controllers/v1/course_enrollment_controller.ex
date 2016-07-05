defmodule PortalApi.V1.CourseEnrollmentController do
  use PortalApi.Web, :controller

  alias PortalApi.CourseEnrollment

  plug :scrub_params, "course_enrollment" when action in [:create, :update]

  def index(conn, _params) do
    course_enrollments = Repo.all(CourseEnrollment)
    render(conn, "index.json", course_enrollments: course_enrollments)
  end

  def create(conn, %{"course_enrollment" => course_enrollment_params}) do
    changeset = CourseEnrollment.changeset(%CourseEnrollment{}, course_enrollment_params)

    case Repo.insert(changeset) do
      {:ok, course_enrollment} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_course_enrollment_path(conn, :show, course_enrollment))
        |> render("show.json", course_enrollment: course_enrollment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    course_enrollment = Repo.get!(CourseEnrollment, id)
    render(conn, "show.json", course_enrollment: course_enrollment)
  end

  def update(conn, %{"id" => id, "course_enrollment" => course_enrollment_params}) do
    course_enrollment = Repo.get!(CourseEnrollment, id)
    changeset = CourseEnrollment.changeset(course_enrollment, course_enrollment_params)

    case Repo.update(changeset) do
      {:ok, course_enrollment} ->
        render(conn, "show.json", course_enrollment: course_enrollment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    course_enrollment = Repo.get!(CourseEnrollment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(course_enrollment)

    send_resp(conn, :no_content, "")
  end
end
