defmodule PortalApi.V1.CertificateController do
  use PortalApi.Web, :controller

  alias PortalApi.Certificate

  plug :scrub_params, "certificate" when action in [:create, :update]

  def index(conn, _params) do
    certificates = Repo.all(Certificate)
    render(conn, "index.json", certificates: certificates)
  end

  def create(conn, %{"certificate" => certificate_params}) do
    changeset = Certificate.changeset(%Certificate{}, certificate_params)

    case Repo.insert(changeset) do
      {:ok, certificate} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_certificate_path(conn, :show, certificate))
        |> render("show.json", certificate: certificate)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    certificate = Repo.get!(Certificate, id)
    render(conn, "show.json", certificate: certificate)
  end

  def update(conn, %{"id" => id, "certificate" => certificate_params}) do
    certificate = Repo.get!(Certificate, id)
    changeset = Certificate.changeset(certificate, certificate_params)

    case Repo.update(changeset) do
      {:ok, certificate} ->
        render(conn, "show.json", certificate: certificate)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    certificate = Repo.get!(Certificate, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(certificate)

    send_resp(conn, :no_content, "")
  end

  defp build_certificate_query(query, [{attr, value} | tail]) do
    query
    |> Ecto.Query.where([sc], field(sc, ^String.to_existing_atom(attr)) == ^value)
    |> build_certificate_query(tail)
  end
  defp build_certificate_query(query, []), do: query
end
