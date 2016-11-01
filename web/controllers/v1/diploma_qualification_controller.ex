defmodule PortalApi.V1.DiplomaQualificationController do
  use PortalApi.Web, :controller

  alias PortalApi.DiplomaQualification

  plug :scrub_params, "diploma_qualification" when action in [:create, :update]

  def index(conn, _params) do
    diploma_qualifications = Repo.all(DiplomaQualification)
    render(conn, "index.json", diploma_qualifications: diploma_qualifications)
  end

  def create(conn, %{"diploma_qualification" => diploma_qualification_params}) do
    changeset = DiplomaQualification.changeset(%DiplomaQualification{}, diploma_qualification_params)

    case Repo.insert(changeset) do
      {:ok, diploma_qualification} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_diploma_qualification_path(conn, :show, diploma_qualification))
        |> render("show.json", diploma_qualification: diploma_qualification)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    diploma_qualification = Repo.get!(DiplomaQualification, id)
    render(conn, "show.json", diploma_qualification: diploma_qualification)
  end

  def update(conn, %{"id" => id, "diploma_qualification" => diploma_qualification_params}) do
    diploma_qualification = Repo.get!(DiplomaQualification, id)
    changeset = DiplomaQualification.changeset(diploma_qualification, diploma_qualification_params)

    case Repo.update(changeset) do
      {:ok, diploma_qualification} ->
        render(conn, "show.json", diploma_qualification: diploma_qualification)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    diploma_qualification = Repo.get!(DiplomaQualification, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(diploma_qualification)

    send_resp(conn, :no_content, "")
  end
end
