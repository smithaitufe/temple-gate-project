defmodule PortalApi.V1.JobPostingController do
  use PortalApi.Web, :controller

  alias PortalApi.JobPosting

  plug :scrub_params, "job_posting" when action in [:create, :update]

  def index(conn, _params) do
    job_postings = Repo.all(JobPosting)
    render(conn, "index.json", job_postings: job_postings)
  end

  def create(conn, %{"job_posting" => job_posting_params}) do
    changeset = JobPosting.changeset(%JobPosting{}, job_posting_params)

    case Repo.insert(changeset) do
      {:ok, job_posting} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_job_posting_path(conn, :show, job_posting))
        |> render("show.json", job_posting: job_posting)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    job_posting = Repo.get!(JobPosting, id)
    render(conn, "show.json", job_posting: job_posting)
  end

  def update(conn, %{"id" => id, "job_posting" => job_posting_params}) do
    job_posting = Repo.get!(JobPosting, id)
    changeset = JobPosting.changeset(job_posting, job_posting_params)

    case Repo.update(changeset) do
      {:ok, job_posting} ->
        render(conn, "show.json", job_posting: job_posting)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    job_posting = Repo.get!(JobPosting, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(job_posting)

    send_resp(conn, :no_content, "")
  end
end
