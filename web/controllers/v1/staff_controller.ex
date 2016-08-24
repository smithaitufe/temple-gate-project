defmodule PortalApi.V1.StaffController do
  use PortalApi.Web, :controller

  alias PortalApi.Staff

  plug :scrub_params, "staff" when action in [:create, :update]

  def index(conn,params) do
    staffs = Staff
    |> build_query(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(associations)

    render(conn, "index.json", staffs: staffs)
  end

  def create(conn, %{"staff" => staff_params}) do
    changeset = Staff.changeset(%Staff{}, staff_params)

    case Repo.insert(changeset) do
      {:ok, staff} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_staff_path(conn, :show, staff))
        |> render("show.json", staff: staff)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    staff = Repo.get!(Staff, id)
    |> Repo.preload(associations)
    render(conn, "show.json", staff: staff)
  end

  def update(conn, %{"id" => id, "staff" => staff_params}) do
    staff = Repo.get!(Staff, id)
    changeset = Staff.changeset(staff, staff_params)

    case Repo.update(changeset) do
      {:ok, staff} ->
        render(conn, "show.json", staff: staff)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    staff = Repo.get!(Staff, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(staff)

    send_resp(conn, :no_content, "")
  end

  defp build_query(query, [{"user_id", user_id} | tail ]) do
    query
    |> Ecto.Query.where([s], s.user_id == ^user_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"department_id", department_id} | tail ]) do
    query
    |> Ecto.Query.join(:inner, [s], sp in assoc(s, :staff_postings))
    |> Ecto.Query.where([s, sp], sp.department_id == ^department_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"active", active} | tail ]) do
    query
    |> Ecto.Query.join(:inner, [s], sp in assoc(s, :staff_postings))
    |> Ecto.Query.where([s, sp], sp.active == ^active)
    |> build_query(tail)
  end

  defp build_query(query, []), do: query

  defp associations do
    [:marital_status, :gender, :local_government_area, :staff_postings]
  end



end
