defmodule PortalApi.V1.AcademicQualificationController do
  use PortalApi.Web, :controller

  alias PortalApi.AcademicQualification

  plug :scrub_params, "academic_qualification" when action in [:create, :update]

  def index(conn, _params) do
    academic_qualifications = Repo.all(AcademicQualification)
    render(conn, "index.json", academic_qualifications: academic_qualifications)
  end

  def create(conn, %{"academic_qualification" => academic_qualification_params}) do
    changeset = AcademicQualification.changeset(%AcademicQualification{}, academic_qualification_params)

    case Repo.insert(changeset) do
      {:ok, academic_qualification} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_academic_qualification_path(conn, :show, academic_qualification))
        |> render("show.json", academic_qualification: academic_qualification)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    academic_qualification = Repo.get!(AcademicQualification, id)
    render(conn, "show.json", academic_qualification: academic_qualification)
  end

  def update(conn, %{"id" => id, "academic_qualification" => academic_qualification_params}) do
    academic_qualification = Repo.get!(AcademicQualification, id)
    changeset = AcademicQualification.changeset(academic_qualification, academic_qualification_params)

    case Repo.update(changeset) do
      {:ok, academic_qualification} ->
        render(conn, "show.json", academic_qualification: academic_qualification)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    academic_qualification = Repo.get!(AcademicQualification, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(academic_qualification)

    send_resp(conn, :no_content, "")
  end
end
