defmodule PortalApi.V1.StaffLeaveRequestController do
  use PortalApi.Web, :controller

  alias PortalApi.StaffLeaveRequest

  plug :scrub_params, "staff_leave_request" when action in [:create, :update]

  def index(conn, params) do
    staff_leave_requests = StaffLeaveRequest
    |> build_query(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(StaffLeaveRequest.associations)

    render(conn, "index.json", staff_leave_requests: staff_leave_requests)
  end

  def create(conn, %{"staff_leave_request" => staff_leave_request_params}) do
    changeset = StaffLeaveRequest.changeset(%StaffLeaveRequest{}, staff_leave_request_params)

    case Repo.insert(changeset) do
      {:ok, staff_leave_request} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_staff_leave_request_path(conn, :show, staff_leave_request))
        |> render("show.json", staff_leave_request: staff_leave_request)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    staff_leave_request = StaffLeaveRequest
    |> Repo.get!(id)
    |> Repo.preload(StaffLeaveRequest.associations)

    render(conn, "show.json", staff_leave_request: staff_leave_request)
  end

  def update(conn, %{"id" => id, "staff_leave_request" => staff_leave_request_params}) do
    staff_leave_request = Repo.get!(StaffLeaveRequest, id)
    changeset = StaffLeaveRequest.changeset(staff_leave_request, staff_leave_request_params)

    case Repo.update(changeset) do
      {:ok, staff_leave_request} ->

        staff_leave_request = staff_leave_request |> Repo.preload(StaffLeaveRequest.associations)

        render(conn, "show.json", staff_leave_request: staff_leave_request)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    staff_leave_request = Repo.get!(StaffLeaveRequest, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(staff_leave_request)

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
