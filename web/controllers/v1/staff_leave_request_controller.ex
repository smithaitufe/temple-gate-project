defmodule PortalApi.V1.StaffLeaveRequestController do
  use PortalApi.Web, :controller

  alias PortalApi.StaffLeaveRequest

  plug :scrub_params, "staff_leave_request" when action in [:create, :update]

  def index(conn, _params) do
    staff_leave_requests = Repo.all(StaffLeaveRequest)
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
    staff_leave_request = Repo.get!(StaffLeaveRequest, id)
    render(conn, "show.json", staff_leave_request: staff_leave_request)
  end

  def update(conn, %{"id" => id, "staff_leave_request" => staff_leave_request_params}) do
    staff_leave_request = Repo.get!(StaffLeaveRequest, id)
    changeset = StaffLeaveRequest.changeset(staff_leave_request, staff_leave_request_params)

    case Repo.update(changeset) do
      {:ok, staff_leave_request} ->
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
end
