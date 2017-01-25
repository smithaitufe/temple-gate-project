defmodule PortalApi.V1.PostSecondaryCertificateController do
  use PortalApi.Web, :controller

  alias PortalApi.PostSecondaryCertificate

  plug :scrub_params, "post_secondary_certificate" when action in [:create, :update]

  def index(conn, _params) do
    post_secondary_certificates = Repo.all(PostSecondaryCertificate)
    render(conn, "index.json", post_secondary_certificates: post_secondary_certificates)
  end

  def create(conn, %{"post_secondary_certificate" => post_secondary_certificate_params}) do
    changeset = PostSecondaryCertificate.changeset(%PostSecondaryCertificate{}, post_secondary_certificate_params)

    case Repo.insert(changeset) do
      {:ok, post_secondary_certificate} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_post_secondary_certificate_path(conn, :show, post_secondary_certificate))
        |> render("show.json", post_secondary_certificate: post_secondary_certificate)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post_secondary_certificate = Repo.get!(PostSecondaryCertificate, id)
    render(conn, "show.json", post_secondary_certificate: post_secondary_certificate)
  end

  def update(conn, %{"id" => id, "post_secondary_certificate" => post_secondary_certificate_params}) do
    post_secondary_certificate = Repo.get!(PostSecondaryCertificate, id)
    changeset = PostSecondaryCertificate.changeset(post_secondary_certificate, post_secondary_certificate_params)

    case Repo.update(changeset) do
      {:ok, post_secondary_certificate} ->
        render(conn, "show.json", post_secondary_certificate: post_secondary_certificate)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post_secondary_certificate = Repo.get!(PostSecondaryCertificate, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post_secondary_certificate)

    send_resp(conn, :no_content, "")
  end
end
