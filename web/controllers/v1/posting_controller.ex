defmodule PortalApi.V1.PostingController do
  use PortalApi.Web, :controller

  alias PortalApi.Posting

  plug :scrub_params, "posting" when action in [:create, :update]

  def index(conn, params) do
    postings = Posting
    |> build_query(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(associations)
    render(conn, "index.json", postings: postings)
  end

  def create(conn, %{"posting" => posting_params}) do
    changeset = Posting.changeset(%Posting{}, posting_params)

    case Repo.insert(changeset) do
      {:ok, posting} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_posting_path(conn, :show, posting))
        |> render("show.json", posting: posting)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    posting = Repo.get!(Posting, id) |> Repo.preload(associations)
    render(conn, "show.json", posting: posting)
  end

  def update(conn, %{"id" => id, "posting" => posting_params}) do
    posting = Repo.get!(Posting, id)
    changeset = Posting.changeset(posting, posting_params)

    case Repo.update(changeset) do
      {:ok, posting} ->
        render(conn, "show.json", posting: posting)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    posting = Repo.get!(Posting, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(posting)

    send_resp(conn, :no_content, "")
  end

  defp build_query(query, []), do: query
  defp build_query(query, [{"department_id", department_id} | tail]) do
    query
    |> Ecto.Query.where([sp], sp.department_id == ^department_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"user_id", user_id} | tail]) do
    query
    |> Ecto.Query.where([sp], sp.user_id == ^user_id)
    |> build_query(tail)
  end
  defp build_query(query, [{"active", active} | tail]) do
    query
    |> Ecto.Query.where([sp], sp.active == ^active)
    |> build_query(tail)
  end

  defp associations do
    [:staff, :department, {:job, [:department_type] }, {:salary_grade_step, [{:salary_grade_level, [:salary_structure_type]} ]} ]   

  end

end
