defmodule PortalApi.V1.CourseTutorController do
  use PortalApi.Web, :controller

  alias PortalApi.CourseTutor

  plug :scrub_params, "course_tutor" when action in [:create, :update]

  def index(conn, params) do

    IO.inspect params
    course_tutors = CourseTutor
    |> Ecto.Query.join(:inner, [ct], c in assoc(ct, :course))
    |> Ecto.Query.join(:inner, [ct, c], a in assoc(ct, :academic_session))
    |> Ecto.Query.join(:inner, [ct, c, a], s in assoc(ct, :staff))
    |> build_query(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(associations)

    render(conn, "index.json", course_tutors: course_tutors)
  end

  def create(conn, %{"course_tutor" => course_tutor_params}) do
    changeset = CourseTutor.changeset(%CourseTutor{}, course_tutor_params)

    case Repo.insert(changeset) do
      {:ok, course_tutor} ->
        course_tutor = Repo.preload(course_tutor, associations)
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
    |> Repo.preload(associations)
    render(conn, "show.json", course_tutor: course_tutor)
  end

  def update(conn, %{"id" => id, "course_tutor" => course_tutor_params}) do
    course_tutor = Repo.get!(CourseTutor, id)
    changeset = CourseTutor.changeset(course_tutor, course_tutor_params)

    case Repo.update(changeset) do
      {:ok, course_tutor} ->

        course_tutor = Repo.preload(course_tutor, associations)
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
  defp build_query(query, []), do: query
  defp build_query(query, [{"academic_session_id", academic_session_id} | tail]) do
    query
    |> Ecto.Query.where([ct, c, a, s], ct.academic_session_id == ^academic_session_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"department_id", department_id} | tail]) do
    query
    |> Ecto.Query.where([ct, c, a, s], c.department_id == ^department_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"staff_id", staff_id} | tail]) do
    query
    |> Ecto.Query.where([ct, c, a, s], ct.staff_id == ^staff_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"level_id", level_id} | tail]) do
    query
    |> Ecto.Query.where([ct, c, a, s], c.level_id == ^level_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"semester_id", semester_id} | tail]) do
    query
    |> Ecto.Query.where([ct, c, a, s], c.semester_id == ^semester_id)
    |> build_query(tail)
  end


  defp associations do
    [:course, :staff, :academic_session]
  end

end
