defmodule PortalApi.V1.LeaveDurationController do
  use PortalApi.Web, :controller

  alias PortalApi.LeaveDuration

  plug :scrub_params, "leave_duration" when action in [:create, :update]

  def index(conn, _params) do
    leave_durations = Repo.all(LeaveDuration)
    render(conn, "index.json", leave_durations: leave_durations)
  end

  def create(conn, %{"leave_duration" => leave_duration_params}) do
    changeset = LeaveDuration.changeset(%LeaveDuration{}, leave_duration_params)

    case Repo.insert(changeset) do
      {:ok, leave_duration} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_leave_duration_path(conn, :show, leave_duration))
        |> render("show.json", leave_duration: leave_duration)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    leave_duration = Repo.get!(LeaveDuration, id)
    render(conn, "show.json", leave_duration: leave_duration)
  end

  def update(conn, %{"id" => id, "leave_duration" => leave_duration_params}) do
    leave_duration = Repo.get!(LeaveDuration, id)
    changeset = LeaveDuration.changeset(leave_duration, leave_duration_params)

    case Repo.update(changeset) do
      {:ok, leave_duration} ->
        render(conn, "show.json", leave_duration: leave_duration)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    leave_duration = Repo.get!(LeaveDuration, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(leave_duration)

    send_resp(conn, :no_content, "")
  end
end
