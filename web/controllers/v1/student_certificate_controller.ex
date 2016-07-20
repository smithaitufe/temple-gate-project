defmodule PortalApi.V1.StudentCertificateController do
  use PortalApi.Web, :controller

  alias PortalApi.StudentCertificate

  plug :scrub_params, "student_certificate" when action in [:create, :update]

  def index(conn, _params) do
    student_certificates = Repo.all(StudentCertificate)
    render(conn, "index.json", student_certificates: student_certificates)
  end

  def create(conn, %{"student_certificate" => student_certificate_params}) do
    changeset = StudentCertificate.changeset(%StudentCertificate{}, student_certificate_params)

    case Repo.insert(changeset) do
      {:ok, student_certificate} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_student_certificate_path(conn, :show, student_certificate))
        |> render("show.json", student_certificate: student_certificate)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    student_certificate = Repo.get!(StudentCertificate, id)
    render(conn, "show.json", student_certificate: student_certificate)
  end

  def update(conn, %{"id" => id, "student_certificate" => student_certificate_params}) do
    student_certificate = Repo.get!(StudentCertificate, id)
    changeset = StudentCertificate.changeset(student_certificate, student_certificate_params)

    case Repo.update(changeset) do
      {:ok, student_certificate} ->
        render(conn, "show.json", student_certificate: student_certificate)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    student_certificate = Repo.get!(StudentCertificate, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(student_certificate)

    send_resp(conn, :no_content, "")
  end
end
