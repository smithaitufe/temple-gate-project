defmodule PortalApi.V1.StaffPostingController do
  use PortalApi.Web, :controller

  alias PortalApi.StaffPosting

  plug :scrub_params, "staff_posting" when action in [:create, :update]

  def index(conn, _params) do
    staff_postings = Repo.all(StaffPosting)
    render(conn, "index.json", staff_postings: staff_postings)
  end

  def create(conn, %{"staff_posting" => staff_posting_params}) do
    changeset = StaffPosting.changeset(%StaffPosting{}, staff_posting_params)

    case Repo.insert(changeset) do
      {:ok, staff_posting} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_staff_posting_path(conn, :show, staff_posting))
        |> render("show.json", staff_posting: staff_posting)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    staff_posting = Repo.get!(StaffPosting, id)
    render(conn, "show.json", staff_posting: staff_posting)
  end

  def update(conn, %{"id" => id, "staff_posting" => staff_posting_params}) do
    staff_posting = Repo.get!(StaffPosting, id)
    changeset = StaffPosting.changeset(staff_posting, staff_posting_params)

    case Repo.update(changeset) do
      {:ok, staff_posting} ->
        render(conn, "show.json", staff_posting: staff_posting)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    staff_posting = Repo.get!(StaffPosting, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(staff_posting)

    send_resp(conn, :no_content, "")
  end
end
