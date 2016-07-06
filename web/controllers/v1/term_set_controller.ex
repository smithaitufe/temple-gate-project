defmodule PortalApi.V1.TermSetController do
  use PortalApi.Web, :controller

  alias PortalApi.TermSet

  plug :scrub_params, "term_set" when action in [:create, :update]

  
  def index(conn, _params) do
    term_sets = Repo.all(TermSet)
    render(conn, "index.json", term_sets: term_sets)
  end

  def create(conn, %{"term_set" => term_set_params}) do
    changeset = TermSet.changeset(%TermSet{}, term_set_params)

    case Repo.insert(changeset) do
      {:ok, term_set} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_term_set_path(conn, :show, term_set))
        |> render("show.json", term_set: term_set)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    term_set = Repo.get!(TermSet, id)
    render(conn, "show.json", term_set: term_set)
  end

  def update(conn, %{"id" => id, "term_set" => term_set_params}) do
    term_set = Repo.get!(TermSet, id)
    changeset = TermSet.changeset(term_set, term_set_params)

    case Repo.update(changeset) do
      {:ok, term_set} ->
        render(conn, "show.json", term_set: term_set)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    term_set = Repo.get!(TermSet, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(term_set)

    send_resp(conn, :no_content, "")
  end
end
