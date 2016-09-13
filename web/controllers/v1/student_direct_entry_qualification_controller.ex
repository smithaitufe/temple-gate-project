defmodule PortalApi.V1.StudentDirectEntryQualificationController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentDirectEntryQualification

  plug :scrub_params, "student_direct_entry_qualification" when action in [:create, :update]

  def index(conn, _params) do
    student_direct_entry_qualifications = Repo.all(StudentDirectEntryQualification)
    render(conn, "index.json", student_direct_entry_qualifications: student_direct_entry_qualifications)
  end

  def create(conn, %{"student_direct_entry_qualification" => student_direct_entry_qualification_params}) do
    changeset = StudentDirectEntryQualification.changeset(%StudentDirectEntryQualification{}, student_direct_entry_qualification_params)

    case Repo.insert(changeset) do
      {:ok, student_direct_entry_qualification} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_direct_entry_qualification_path(conn, :show, student_direct_entry_qualification))
        |> render("show.json", student_direct_entry_qualification: student_direct_entry_qualification)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student_direct_entry_qualification = Repo.get!(StudentDirectEntryQualification, id)
    render(conn, "show.json", student_direct_entry_qualification: student_direct_entry_qualification)
  end

  def update(conn, %{"id" => id, "student_direct_entry_qualification" => student_direct_entry_qualification_params}) do
    student_direct_entry_qualification = Repo.get!(StudentDirectEntryQualification, id)
    changeset = StudentDirectEntryQualification.changeset(student_direct_entry_qualification, student_direct_entry_qualification_params)

    case Repo.update(changeset) do
      {:ok, student_direct_entry_qualification} ->
        render(conn, "show.json", student_direct_entry_qualification: student_direct_entry_qualification)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student_direct_entry_qualification = Repo.get!(StudentDirectEntryQualification, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_direct_entry_qualification)

    send_resp(conn, :no_content, "")
  end
end
