defmodule PortalApi.V1.ProgramApplicationPostSecondaryCertificateController do
  use PortalApi.Web, :controller

  alias PortalApi.ProgramApplicationPostSecondaryCertificate

  def index(conn, _params) do
    program_application_post_secondary_certificates = Repo.all(ProgramApplicationPostSecondaryCertificate)
    render(conn, "index.json", program_application_post_secondary_certificates: program_application_post_secondary_certificates)
  end

  def create(conn, %{"program_application_post_secondary_certificate" => program_application_post_secondary_certificate_params}) do
    changeset = ProgramApplicationPostSecondaryCertificate.changeset(%ProgramApplicationPostSecondaryCertificate{}, program_application_post_secondary_certificate_params)

    case Repo.insert(changeset) do
      {:ok, program_application_post_secondary_certificate} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_program_application_post_secondary_certificate_path(conn, :show, program_application_post_secondary_certificate))
        |> render("show.json", program_application_post_secondary_certificate: program_application_post_secondary_certificate)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    program_application_post_secondary_certificate = Repo.get!(ProgramApplicationPostSecondaryCertificate, id)
    render(conn, "show.json", program_application_post_secondary_certificate: program_application_post_secondary_certificate)
  end

  def update(conn, %{"id" => id, "program_application_post_secondary_certificate" => program_application_post_secondary_certificate_params}) do
    program_application_post_secondary_certificate = Repo.get!(ProgramApplicationPostSecondaryCertificate, id)
    changeset = ProgramApplicationPostSecondaryCertificate.changeset(program_application_post_secondary_certificate, program_application_post_secondary_certificate_params)

    case Repo.update(changeset) do
      {:ok, program_application_post_secondary_certificate} ->
        render(conn, "show.json", program_application_post_secondary_certificate: program_application_post_secondary_certificate)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    program_application_post_secondary_certificate = Repo.get!(ProgramApplicationPostSecondaryCertificate, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(program_application_post_secondary_certificate)

    send_resp(conn, :no_content, "")
  end
end
