defmodule PortalApi.V1.FacultyHeadController do
  use PortalApi.Web, :controller

  alias PortalApi.FacultyHead

  plug :scrub_params, "faculty_head" when action in [:create, :update]

  def index(conn, params) do
    faculty_heads = FacultyHead
    |> build_faculty_head_query(Map.to_list(params))
    |> Repo.all

    render(conn, "index.json", faculty_heads: faculty_heads)
  end

  def create(conn, %{"faculty_head" => faculty_head_params}) do
    changeset = FacultyHead.changeset(%FacultyHead{}, faculty_head_params)

    case Repo.insert(changeset) do
      {:ok, faculty_head} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_faculty_head_path(conn, :show, faculty_head))
        |> render("show.json", faculty_head: faculty_head)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    faculty_head = Repo.get!(FacultyHead, id)
    render(conn, "show.json", faculty_head: faculty_head)
  end

  def update(conn, %{"id" => id, "faculty_head" => faculty_head_params}) do
    faculty_head = Repo.get!(FacultyHead, id)
    changeset = FacultyHead.changeset(faculty_head, faculty_head_params)

    case Repo.update(changeset) do
      {:ok, faculty_head} ->
        render(conn, "show.json", faculty_head: faculty_head)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    faculty_head = Repo.get!(FacultyHead, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(faculty_head)

    send_resp(conn, :no_content, "")
  end


  defp build_faculty_head_query(query, []), do: query
  defp build_faculty_head_query(query, [{"staff_id", staff_id} | tail ]) do
    query
    |> Ecto.Query.where([fh], fh.staff_id == ^staff_id)
    |> build_faculty_head_query(tail)
  end
  defp build_faculty_head_query(query, [{"faculty_id", faculty_id} | tail ]) do
    query
    |> Ecto.Query.where([fh], fh.faculty_id == ^faculty_id)
    |> build_faculty_head_query(tail)
  end
  defp build_faculty_head_query(query, [{"active", active} | tail ]) do
    query
    |> Ecto.Query.where([fh], fh.active == ^active)
    |> build_faculty_head_query(tail)
  end
end
