defmodule PortalApi.V1.TermController do
  use PortalApi.Web, :controller

  alias PortalApi.Term

  plug :scrub_params, "term" when action in [:create, :update]


  # def index(conn, %{"name" => name}) do
  #   query = from t in Term, join: ts in assoc(t, :term_set), where: ts.name == ^name
  #   terms = Repo.all query
  #   render(conn, "index.json", terms: terms)
  # end
  def index(conn, params) do
    terms = Term
    |> build_term_query(Map.to_list(params))
    |> Repo.all

    render(conn, "index.json", terms: terms)
  end

  def create(conn, %{"term" => term_params}) do
    changeset = Term.changeset(%Term{}, term_params)

    case Repo.insert(changeset) do
      {:ok, term} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_term_path(conn, :show, term))
        |> render("show.json", term: term)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    term = Repo.get!(Term, id)
    render(conn, "show.json", term: term)
  end

  def update(conn, %{"id" => id, "term" => term_params}) do
    term = Repo.get!(Term, id)
    changeset = Term.changeset(term, term_params)

    case Repo.update(changeset) do
      {:ok, term} ->
        render(conn, "show.json", term: term)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    term = Repo.get!(Term, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(term)

    send_resp(conn, :no_content, "")
  end


  defp build_term_query(query, [{"name", name} | tail]) do
    query
    |> Ecto.Query.join(:inner, [t], ts in assoc(t, :term_set))
    |> Ecto.Query.where([t, ts], ts.name == ^name)
    |> build_term_query(tail)
  end
  defp build_term_query(query, [{"description", description} | tail]) do
    query
    |> Ecto.Query.join(:inner, [t], ts in assoc(t, :term_set))
    |> Ecto.Query.where([t, ts], fragment("lower(?) = ?", t.description, ^String.downcase(description)))
    |> build_term_query(tail)
  end
  defp build_term_query(query, [{"term_set_id", term_set_id} | tail]) do
    query
    # |> Ecto.Query.join(:inner, [t], ts in assoc(t, :term_set))
    |> Ecto.Query.where([t], t.term_set_id == ^term_set_id)
    |> build_term_query(tail)
  end
  defp build_term_query(query, []), do: query

end
