defmodule PortalApi.V1.PostPrimaryCertificateItemController do
  use PortalApi.Web, :controller

  alias PortalApi.PostPrimaryCertificateItem

  plug :scrub_params, "post_primary_certificate_item" when action in [:create, :update]

  def index(conn, _params) do
    post_primary_certificate_items = Repo.all(PostPrimaryCertificateItem)
    render(conn, "index.json", post_primary_certificate_items: post_primary_certificate_items)
  end

  def create(conn, %{"post_primary_certificate_item" => post_primary_certificate_item_params}) do
    changeset = PostPrimaryCertificateItem.changeset(%PostPrimaryCertificateItem{}, post_primary_certificate_item_params)

    case Repo.insert(changeset) do
      {:ok, post_primary_certificate_item} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_post_primary_certificate_item_path(conn, :show, post_primary_certificate_item))
        |> render("show.json", post_primary_certificate_item: post_primary_certificate_item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post_primary_certificate_item = Repo.get!(PostPrimaryCertificateItem, id)
    render(conn, "show.json", post_primary_certificate_item: post_primary_certificate_item)
  end

  def update(conn, %{"id" => id, "post_primary_certificate_item" => post_primary_certificate_item_params}) do
    post_primary_certificate_item = Repo.get!(PostPrimaryCertificateItem, id)
    changeset = PostPrimaryCertificateItem.changeset(post_primary_certificate_item, post_primary_certificate_item_params)

    case Repo.update(changeset) do
      {:ok, post_primary_certificate_item} ->
        render(conn, "show.json", post_primary_certificate_item: post_primary_certificate_item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post_primary_certificate_item = Repo.get!(PostPrimaryCertificateItem, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post_primary_certificate_item)

    send_resp(conn, :no_content, "")
  end
end
