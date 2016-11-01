defmodule PortalApi.V1.CourseEnrollmentController do
  use PortalApi.Web, :controller

  alias PortalApi.CourseEnrollment

  plug :scrub_params, "course_enrollment" when action in [:create, :update]

  def index(conn, params) do
    course_enrollments = CourseEnrollment
    |> Ecto.Query.join(:inner, [sc], a in assoc(sc, :academic_session))
    |> Ecto.Query.join(:inner, [sc, a], c in assoc(sc, :course))
    |> build_query(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(CourseEnrollment.associations)

    render(conn, "index.json", course_enrollments: course_enrollments)
  end

  def create(conn, %{"course_enrollment" => course_enrollment_params}) do
    changeset = CourseEnrollment.changeset(%CourseEnrollment{}, course_enrollment_params)

    case Repo.insert(changeset) do
      {:ok, course_enrollment} ->
        course_enrollment = course_enrollment |> Repo.preload(CourseEnrollment.associations)
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
    course_enrollment = Repo.get!(CourseEnrollment, id) |> Repo.preload(CourseEnrollment.associations)

    render(conn, "show.json", course_enrollment: course_enrollment)
  end

  def update(conn, %{"id" => id, "course_enrollment" => course_enrollment_params}) do
    course_enrollment = Repo.get!(CourseEnrollment, id)
    changeset = CourseEnrollment.changeset(course_enrollment, course_enrollment_params)
    case Repo.update(changeset) do
      {:ok, course_enrollment} ->
        course_enrollment = course_enrollment |> Repo.preload(CourseEnrollment.associations)
        render(conn, "show.json", course_enrollment: course_enrollment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"user_id" => user_id, "id" => id}) do
    course_enrollment = Repo.get_by!(CourseEnrollment, [user_id: user_id, id: id])

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(course_enrollment)

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

  defp build_query(query, [{"enrolled_by_user_id", enrolled_by_user_id} | tail]) do
    query
    |> Ecto.Query.where([sc, _, _], sc.enrolled_by_user_id == ^enrolled_by_user_id)
    |> build_query(tail)
  end

end