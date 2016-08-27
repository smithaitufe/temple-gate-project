defmodule PortalApi.V1.StaffLeaveEntitlementController do
  use PortalApi.Web, :controller

  alias PortalApi.StaffLeaveEntitlement

  plug :scrub_params, "staff_leave_entitlement" when action in [:create, :update]

  def index(conn, _params) do
    staff_leave_entitlements = Repo.all(StaffLeaveEntitlement)
    render(conn, "index.json", staff_leave_entitlements: staff_leave_entitlements)
  end

  def create(conn, %{"staff_leave_entitlement" => staff_leave_entitlement_params}) do
    changeset = StaffLeaveEntitlement.changeset(%StaffLeaveEntitlement{}, staff_leave_entitlement_params)

    case Repo.insert(changeset) do
      {:ok, staff_leave_entitlement} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_staff_leave_entitlement_path(conn, :show, staff_leave_entitlement))
        |> render("show.json", staff_leave_entitlement: staff_leave_entitlement)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    staff_leave_entitlement = Repo.get!(StaffLeaveEntitlement, id)
    render(conn, "show.json", staff_leave_entitlement: staff_leave_entitlement)
  end

  def update(conn, %{"id" => id, "staff_leave_entitlement" => staff_leave_entitlement_params}) do
    staff_leave_entitlement = Repo.get!(StaffLeaveEntitlement, id)
    changeset = StaffLeaveEntitlement.changeset(staff_leave_entitlement, staff_leave_entitlement_params)

    case Repo.update(changeset) do
      {:ok, staff_leave_entitlement} ->
        render(conn, "show.json", staff_leave_entitlement: staff_leave_entitlement)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    staff_leave_entitlement = Repo.get!(StaffLeaveEntitlement, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(staff_leave_entitlement)

    send_resp(conn, :no_content, "")
  end
end
