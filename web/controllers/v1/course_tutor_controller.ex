defmodule PortalApi.V1.CourseTutorController do
  use PortalApi.Web, :controller

  alias PortalApi.CourseTutor

  plug :scrub_params, "course_tutor" when action in [:create, :update]

  def index(conn, params) do

    IO.inspect params
    course_tutors = CourseTutor
    |> Ecto.Query.join(:inner, [ct], c in assoc(ct, :course))    
    |> Ecto.Query.join(:inner, [ct, c], a in assoc(ct, :academic_session))
    |> Ecto.Query.join(:inner, [ct, c, a], s in assoc(ct, :tutor))
    |> Ecto.Query.join(:inner, [ct, c, a, s], l in assoc(c, :level))
    |> build_query(Map.to_list(params))
    |> Ecto.Query.distinct(true)
    |> Repo.all
    |> Repo.preload(CourseTutor.associations)

    render(conn, "index.json", course_tutors: course_tutors)
  end

  def create(conn, %{"course_tutor" => course_tutor_params}) do
    changeset = CourseTutor.changeset(%CourseTutor{}, course_tutor_params)

    case Repo.insert(changeset) do
      {:ok, course_tutor} ->
        course_tutor = course_tutor |> Repo.preload(CourseTutor.associations)
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
    |> Repo.preload(CourseTutor.associations)

    render(conn, "show.json", course_tutor: course_tutor)
  end

  def update(conn, %{"id" => id, "course_tutor" => course_tutor_params}) do
    course_tutor = Repo.get!(CourseTutor, id)
    changeset = CourseTutor.changeset(course_tutor, course_tutor_params)

    case Repo.update(changeset) do
      {:ok, course_tutor} ->

        course_tutor = course_tutor |> Repo.preload(CourseTutor.associations)
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
  defp build_query(query, [{"tutor_user_id", tutor_user_id} | tail]) do
    query
    |> Ecto.Query.where([ct, c, a, s], ct.tutor_user_id == ^tutor_user_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"program_id", program_id} | tail]) do
    query
    |> Ecto.Query.where([_,_,_,_, l], l.program_id == ^program_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"level_id", level_id} | tail]) do
    query
    |> Ecto.Query.where([_, c, _, _,_], c.level_id == ^level_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"semester_id", semester_id} | tail]) do
    query
    |> Ecto.Query.where([ct, c, a, s], c.semester_id == ^semester_id)
    |> build_query(tail)
  end



end
