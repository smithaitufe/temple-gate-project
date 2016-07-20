defmodule PortalApi.V1.StudentDiplomaQualificationController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentDiplomaQualification

  plug :scrub_params, "student_diploma_qualification" when action in [:create, :update]

  def index(conn, _params) do
    student_diploma_qualifications = Repo.all(StudentDiplomaQualification)
    render(conn, "index.json", student_diploma_qualifications: student_diploma_qualifications)
  end

  def create(conn, %{"student_diploma_qualification" => student_diploma_qualification_params}) do
    changeset = StudentDiplomaQualification.changeset(%StudentDiplomaQualification{}, student_diploma_qualification_params)

    case Repo.insert(changeset) do
      {:ok, student_diploma_qualification} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_diploma_qualification_path(conn, :show, student_diploma_qualification))
        |> render("show.json", student_diploma_qualification: student_diploma_qualification)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student_diploma_qualification = Repo.get!(StudentDiplomaQualification, id)
    render(conn, "show.json", student_diploma_qualification: student_diploma_qualification)
  end

  def update(conn, %{"id" => id, "student_diploma_qualification" => student_diploma_qualification_params}) do
    student_diploma_qualification = Repo.get!(StudentDiplomaQualification, id)
    changeset = StudentDiplomaQualification.changeset(student_diploma_qualification, student_diploma_qualification_params)

    case Repo.update(changeset) do
      {:ok, student_diploma_qualification} ->
        render(conn, "show.json", student_diploma_qualification: student_diploma_qualification)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student_diploma_qualification = Repo.get!(StudentDiplomaQualification, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_diploma_qualification)

    send_resp(conn, :no_content, "")
  end
end
