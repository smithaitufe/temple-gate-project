defmodule PortalApi.V1.LeaveRequestController do
  use PortalApi.Web, :controller

  alias PortalApi.LeaveRequest

  plug :scrub_params, "leave_request" when action in [:create, :update]

  def index(conn, params) do
    leave_requests = LeaveRequest
    |> build_query(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(LeaveRequest.associations)

    render(conn, "index.json", leave_requests: leave_requests)
  end

  def create(conn, %{"leave_request" => leave_request_params}) do
    changeset = LeaveRequest.changeset(%LeaveRequest{}, leave_request_params)

    case Repo.insert(changeset) do
      {:ok, leave_request} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_leave_request_path(conn, :show, leave_request))
        |> render("show.json", leave_request: leave_request)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    leave_request = LeaveRequest
    |> Repo.get!(id)
    |> Repo.preload(LeaveRequest.associations)

    render(conn, "show.json", leave_request: leave_request)
  end

  def update(conn, %{"id" => id, "leave_request" => leave_request_params}) do
    leave_request = Repo.get!(LeaveRequest, id)
    changeset = LeaveRequest.changeset(leave_request, leave_request_params)

    case Repo.update(changeset) do
      {:ok, leave_request} ->

        leave_request = leave_request |> Repo.preload(LeaveRequest.associations)

        render(conn, "show.json", leave_request: leave_request)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    leave_request = Repo.get!(LeaveRequest, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(leave_request)

    send_resp(conn, :no_content, "")
  end

  defp build_query(query, [{"staff_id", staff_id} | tail ]) do
    query
    |> Ecto.Query.where([slr],slr.staff_id == ^staff_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"approved", approved} | tail ]) do
    query
    |> Ecto.Query.where([slr],slr.approved == ^approved)
    |> build_query(tail)
  end
  defp build_query(query, [{"closed", closed} | tail ]) do
    query
    |> Ecto.Query.where([slr],slr.closed == ^closed)
    |> build_query(tail)
  end
  defp build_query(query, [{attr, value} | tail]) when attr == "month" or attr == "year" do
    query
    |> Ecto.Query.where([slr], fragment("date_part(?, ?) = ?", ^attr, slr.proposed_start_date, type(^value, :integer)))
    |> build_query(tail)
  end

  defp build_query(query, []), do: query




end
