defmodule PortalApi.V1.JobTitleController do
  use PortalApi.Web, :controller

  alias PortalApi.JobTitle

  plug :scrub_params, "job_title" when action in [:create, :update]

  def index(conn, _params) do
    job_titles = Repo.all(JobTitle)
    render(conn, "index.json", job_titles: job_titles)
  end

  def create(conn, %{"job_title" => job_title_params}) do
    changeset = JobTitle.changeset(%JobTitle{}, job_title_params)

    case Repo.insert(changeset) do
      {:ok, job_title} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_job_title_path(conn, :show, job_title))
        |> render("show.json", job_title: job_title)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    job_title = Repo.get!(JobTitle, id)
    render(conn, "show.json", job_title: job_title)
  end

  def update(conn, %{"id" => id, "job_title" => job_title_params}) do
    job_title = Repo.get!(JobTitle, id)
    changeset = JobTitle.changeset(job_title, job_title_params)

    case Repo.update(changeset) do
      {:ok, job_title} ->
        render(conn, "show.json", job_title: job_title)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    job_title = Repo.get!(JobTitle, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(job_title)

    send_resp(conn, :no_content, "")
  end
end
