defmodule PortalApi.V1.CourseTutorController do
  use PortalApi.Web, :controller

  alias PortalApi.CourseTutor

  plug :scrub_params, "course_tutor" when action in [:create, :update]

  def index(conn, _params) do
    course_tutors = Repo.all(CourseTutor)
    render(conn, "index.json", course_tutors: course_tutors)
  end

  def create(conn, %{"course_tutor" => course_tutor_params}) do
    changeset = CourseTutor.changeset(%CourseTutor{}, course_tutor_params)

    case Repo.insert(changeset) do
      {:ok, course_tutor} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_course_tutor_path(conn, :show, course_tutor))
        |> render("show.json", course_tutor: course_tutor)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    course_tutor = Repo.get!(CourseTutor, id)
    render(conn, "show.json", course_tutor: course_tutor)
  end

  def update(conn, %{"id" => id, "course_tutor" => course_tutor_params}) do
    course_tutor = Repo.get!(CourseTutor, id)
    changeset = CourseTutor.changeset(course_tutor, course_tutor_params)

    case Repo.update(changeset) do
      {:ok, course_tutor} ->
        render(conn, "show.json", course_tutor: course_tutor)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    course_tutor = Repo.get!(CourseTutor, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(course_tutor)

    send_resp(conn, :no_content, "")
  end
end
