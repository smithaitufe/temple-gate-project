defmodule PortalApi.V1.GradeChangeRequestController do
  use PortalApi.Web, :controller

  alias PortalApi.GradeChangeRequest

  plug :scrub_params, "grade_change_request" when action in [:create, :update]

  def index(conn, params) do
    grade_change_requests = GradeChangeRequest
    |> build_query(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(GradeChangeRequest.associations)

    render(conn, "index.json", grade_change_requests: grade_change_requests)
  end

  def create(conn, %{"grade_change_request" => grade_change_request_params}) do
    changeset = GradeChangeRequest.changeset(%GradeChangeRequest{}, grade_change_request_params)

    case Repo.insert(changeset) do
      {:ok, grade_change_request} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_grade_change_request_path(conn, :show, grade_change_request))
        |> render("show.json", grade_change_request: grade_change_request)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    grade_change_request = Repo.get!(GradeChangeRequest, id)
    render(conn, "show.json", grade_change_request: grade_change_request)
  end

  def update(conn, %{"id" => id, "grade_change_request" => grade_change_request_params}) do
    grade_change_request = Repo.get!(GradeChangeRequest, id)
    changeset = GradeChangeRequest.changeset(grade_change_request, grade_change_request_params)

    case Repo.update(changeset) do
      {:ok, grade_change_request} ->
        render(conn, "show.json", grade_change_request: grade_change_request)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    grade_change_request = Repo.get!(GradeChangeRequest, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(grade_change_request)

    send_resp(conn, :no_content, "")
  end

  def build_query(query, [{"student_course_grading_id", student_course_grading_id} | tail ]) do
    query
    |> Ecto.Query.where([gcr], gcr.student_course_grading_id == ^student_course_grading_id)
    |> build_query(tail)
  end
  def build_query(query, [{"read", read} | tail ]) do
    query
    |> Ecto.Query.where([gcr], gcr.read == ^read)
    |> build_query(tail)
  end
  def build_query(query, [{"approved", approved} | tail ]) do
    query
    |> Ecto.Query.where([gcr], gcr.approved == ^approved)
    |> build_query(tail)
  end
  def build_query(query, [{"closed", closed} | tail ]) do
    query
    |> Ecto.Query.where([gcr], gcr.closed == ^closed)
    |> build_query(tail)
  end
  def build_query(query, [{"closed_by", closed_by} | tail ]) do
    query
    |> Ecto.Query.where([gcr], gcr.closed_by_staff_id == ^closed_by)
    |> build_query(tail)
  end
  def build_query(query, []), do: query

end
