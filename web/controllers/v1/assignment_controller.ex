defmodule PortalApi.V1.AssignmentController do
  use PortalApi.Web, :controller

  alias PortalApi.Assignment

  plug :scrub_params, "assignment" when action in [:create, :update]

  def index(conn, params) do
    assignments = Assignment
    |> Ecto.Query.join(:inner, [assignment], course in assoc(assignment, :course))
    |> Ecto.Query.join(:inner, [assignment, course], level in assoc(course, :level))
    |> build_query(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(Assignment.associations)

    render(conn, "index.json", assignments: assignments)
  end

  def create(conn, %{"assignment" => assignment_params}) do
    changeset = Assignment.changeset(%Assignment{}, assignment_params)

    case Repo.insert(changeset) do
      {:ok, assignment} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_assignment_path(conn, :show, assignment))
        |> render("show.json", assignment: assignment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    assignment = Repo.get!(Assignment, id)
    |> Repo.preload(Assignment.associations)

    render(conn, "show.json", assignment: assignment)
  end

  def update(conn, %{"id" => id, "assignment" => assignment_params}) do
    assignment = Repo.get!(Assignment, id)
    changeset = Assignment.changeset(assignment, assignment_params)

    case Repo.update(changeset) do
      {:ok, assignment} ->
        render(conn, "show.json", assignment: assignment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    assignment = Repo.get!(Assignment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(assignment)

    send_resp(conn, :no_content, "")
  end


  defp build_query(query, [{"department_id", department_id } | tail]) do
    query
    # |> Ecto.Query.join(:inner, [assignment], course in assoc(assignment, :course))
    |> Ecto.Query.where([assignment, course], course.department_id == ^department_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"program_id", program_id } | tail]) do
    query
    # |> Ecto.Query.join(:inner, [assignment], course in assoc(assignment, :course))
    # |> Ecto.Query.join(:inner, [assignment, course], level in assoc(course, :level))
    |> Ecto.Query.where([assignment, course, level], level.program_id == ^program_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"level_id", level_id } | tail]) do
    query
    # |> Ecto.Query.join(:inner, [assignment], course in assoc(assignment, :course))
    |> Ecto.Query.where([assignment, course], course.level_id == ^level_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"semester_id", semester_id } | tail]) do
    query
    # |> Ecto.Query.join(:inner, [assignment], course in assoc(assignment, :course))
    |> Ecto.Query.where([assignment, course], course.semester_id == ^semester_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"course_id", course_id } | tail]) do
    query
    |> Ecto.Query.where([assignment], assignment.course_id == ^course_id)
    |> build_query(tail)
  end

  defp build_query(query, [{"status", "started" } | tail]) do
    date_time = %{current_date: date, current_time: time} = get_datetime_map
    query
    |> Ecto.Query.where([assignment], assignment.start_date >= ^date and assignment.start_time >= ^time)
    |> Ecto.Query.where([assignment], assignment.start_date <= assignment.stop_date)
    |> build_query(tail)
  end
  defp build_query(query, [{"status", "pending" } | tail]) do
    date_time = %{current_date: date, current_time: time} = get_datetime_map
    query
    |> Ecto.Query.where([assignment], assignment.start_date >= ^date)
    |> Ecto.Query.where([assignment], assignment.start_date <= assignment.stop_date)
    |> build_query(tail)
  end
  defp build_query(query, [{"status", "closed" } | tail]) do
    date_time = %{current_date: date} = get_datetime_map
    IO.inspect date
    query
    |> Ecto.Query.where([assignment], assignment.stop_date < ^date)
    |> build_query(tail)
  end

  defp build_query(query, [{"start_date", start_date } | tail]) do
    query
    |> Ecto.Query.where([assignment], assignment.start_date == ^start_date)
    |> build_query(tail)
  end
  defp build_query(query, [{"start_time", start_time } | tail]) do
    query
    |> Ecto.Query.where([assignment], assignment.start_time == ^start_time)
    |> build_query(tail)
  end
  defp build_query(query, [{"stop_date", stop_date } | tail]) do
    query
    |> Ecto.Query.where([assignment], assignment.stop_date == ^stop_date)
    |> build_query(tail)
  end
  defp build_query(query, [{"stop_time", stop_time } | tail]) do
    query
    |> Ecto.Query.where([assignment], assignment.stop_time == ^stop_time)
    |> build_query(tail)
  end
  defp build_query(query, []), do: query
  defp get_datetime_map do
    date_time = DateTime.utc_now()
    date =  date_time |> DateTime.to_date
    time = date_time |> DateTime.to_time
    %{current_date: date, current_time: time}
  end
end
