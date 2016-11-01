defmodule PortalApi.V1.DirectEntryQualificationController do
  use PortalApi.Web, :controller

  alias PortalApi.DirectEntryQualification

  plug :scrub_params, "direct_entry_qualification" when action in [:create, :update]

  def index(conn, _params) do
    direct_entry_qualifications = Repo.all(DirectEntryQualification)
    render(conn, "index.json", direct_entry_qualifications: direct_entry_qualifications)
  end

  def create(conn, %{"direct_entry_qualification" => direct_entry_qualification_params}) do
    changeset = DirectEntryQualification.changeset(%DirectEntryQualification{}, direct_entry_qualification_params)

    case Repo.insert(changeset) do
      {:ok, direct_entry_qualification} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_direct_entry_qualification_path(conn, :show, direct_entry_qualification))
        |> render("show.json", direct_entry_qualification: direct_entry_qualification)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    direct_entry_qualification = Repo.get!(DirectEntryQualification, id)
    render(conn, "show.json", direct_entry_qualification: direct_entry_qualification)
  end

  def update(conn, %{"id" => id, "direct_entry_qualification" => direct_entry_qualification_params}) do
    direct_entry_qualification = Repo.get!(DirectEntryQualification, id)
    changeset = DirectEntryQualification.changeset(direct_entry_qualification, direct_entry_qualification_params)

    case Repo.update(changeset) do
      {:ok, direct_entry_qualification} ->
        render(conn, "show.json", direct_entry_qualification: direct_entry_qualification)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    direct_entry_qualification = Repo.get!(DirectEntryQualification, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(direct_entry_qualification)

    send_resp(conn, :no_content, "")
  end
end
