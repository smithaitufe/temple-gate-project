defmodule PortalApi.V1.CertificateItemController do
  use PortalApi.Web, :controller

  alias PortalApi.CertificateItem

  plug :scrub_params, "certificate_item" when action in [:create, :update]

  def index(conn, _params) do
    certificate_items = Repo.all(CertificateItem)
    render(conn, "index.json", certificate_items: certificate_items)
  end

  def create(conn, %{"certificate_item" => certificate_item_params}) do
    changeset = CertificateItem.changeset(%CertificateItem{}, certificate_item_params)

    case Repo.insert(changeset) do
      {:ok, certificate_item} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_certificate_item_path(conn, :show, certificate_item))
        |> render("show.json", certificate_item: certificate_item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    certificate_item = Repo.get!(CertificateItem, id)
    render(conn, "show.json", certificate_item: certificate_item)
  end

  def update(conn, %{"id" => id, "certificate_item" => certificate_item_params}) do
    certificate_item = Repo.get!(CertificateItem, id)
    changeset = CertificateItem.changeset(certificate_item, certificate_item_params)

    case Repo.update(changeset) do
      {:ok, certificate_item} ->
        render(conn, "show.json", certificate_item: certificate_item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    certificate_item = Repo.get!(CertificateItem, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(certificate_item)

    send_resp(conn, :no_content, "")
  end
end
