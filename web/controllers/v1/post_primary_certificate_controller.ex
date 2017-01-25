defmodule PortalApi.V1.PostPrimaryCertificateController do
  use PortalApi.Web, :controller

  alias PortalApi.PostPrimaryCertificate

  plug :scrub_params, "post_primary_certificate" when action in [:create, :update]

  def index(conn, _params) do
    post_primary_certificates = Repo.all(PostPrimaryCertificate)
    render(conn, "index.json", post_primary_certificates: post_primary_certificates)
  end

  def create(conn, %{"post_primary_certificate" => post_primary_certificate_params}) do
    changeset = PostPrimaryCertificate.changeset(%PostPrimaryCertificate{}, post_primary_certificate_params)

    case Repo.insert(changeset) do
      {:ok, post_primary_certificate} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_post_primary_certificate_path(conn, :show, post_primary_certificate))
        |> render("show.json", post_primary_certificate: post_primary_certificate)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post_primary_certificate = Repo.get!(PostPrimaryCertificate, id)
    render(conn, "show.json", post_primary_certificate: post_primary_certificate)
  end

  def update(conn, %{"id" => id, "post_primary_certificate" => post_primary_certificate_params}) do
    post_primary_certificate = Repo.get!(PostPrimaryCertificate, id)
    changeset = PostPrimaryCertificate.changeset(post_primary_certificate, post_primary_certificate_params)

    case Repo.update(changeset) do
      {:ok, post_primary_certificate} ->
        render(conn, "show.json", post_primary_certificate: post_primary_certificate)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post_primary_certificate = Repo.get!(PostPrimaryCertificate, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post_primary_certificate)

    send_resp(conn, :no_content, "")
  end

  defp build_query(query, [{attr, value} | tail]) do
    query
    |> Ecto.Query.where([sc], field(sc, ^String.to_existing_atom(attr)) == ^value)
    |> build_query(tail)
  end
  defp build_query(query, []), do: query
end
