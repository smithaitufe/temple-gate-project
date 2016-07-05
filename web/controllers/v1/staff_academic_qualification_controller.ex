defmodule PortalApi.V1.StaffAcademicQualificationController do
  use PortalApi.Web, :controller

  alias PortalApi.StaffAcademicQualification

  plug :scrub_params, "staff_academic_qualification" when action in [:create, :update]

  def index(conn, _params) do
    staff_academic_qualifications = Repo.all(StaffAcademicQualification)
    render(conn, "index.json", staff_academic_qualifications: staff_academic_qualifications)
  end

  def create(conn, %{"staff_academic_qualification" => staff_academic_qualification_params}) do
    changeset = StaffAcademicQualification.changeset(%StaffAcademicQualification{}, staff_academic_qualification_params)

    case Repo.insert(changeset) do
      {:ok, staff_academic_qualification} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_staff_academic_qualification_path(conn, :show, staff_academic_qualification))
        |> render("show.json", staff_academic_qualification: staff_academic_qualification)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    staff_academic_qualification = Repo.get!(StaffAcademicQualification, id)
    render(conn, "show.json", staff_academic_qualification: staff_academic_qualification)
  end

  def update(conn, %{"id" => id, "staff_academic_qualification" => staff_academic_qualification_params}) do
    staff_academic_qualification = Repo.get!(StaffAcademicQualification, id)
    changeset = StaffAcademicQualification.changeset(staff_academic_qualification, staff_academic_qualification_params)

    case Repo.update(changeset) do
      {:ok, staff_academic_qualification} ->
        render(conn, "show.json", staff_academic_qualification: staff_academic_qualification)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    staff_academic_qualification = Repo.get!(StaffAcademicQualification, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(staff_academic_qualification)

    send_resp(conn, :no_content, "")
  end
end
