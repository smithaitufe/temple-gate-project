defmodule PortalApi.V1.CourseRegistrationSettingController do
  use PortalApi.Web, :controller

  alias PortalApi.CourseRegistrationSetting

  plug :scrub_params, "course_registration_setting" when action in [:create, :update]

  def index(conn, params) do
    course_registration_settings = CourseRegistrationSetting
    |> build_filters(Map.to_list(params))
    |> Repo.all
    |> Repo.preload(CourseRegistrationSetting.associations)

    render(conn, "index.json", course_registration_settings: course_registration_settings)
  end

  def create(conn, %{"course_registration_setting" => course_registration_setting_params}) do
    changeset = CourseRegistrationSetting.changeset(%CourseRegistrationSetting{}, course_registration_setting_params)

    case Repo.insert(changeset) do
      {:ok, course_registration_setting} ->
        course_registration_setting = course_registration_setting|> Repo.preload(CourseRegistrationSetting.associations)
        conn
        |> put_status(:created)
        |> put_resp_header("location", v1_course_registration_setting_path(conn, :show, course_registration_setting))
        |> render("show.json", course_registration_setting: course_registration_setting)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    course_registration_setting = Repo.get(CourseRegistrationSetting, id) |> Repo.preload(CourseRegistrationSetting.associations)

    render(conn, "show.json", course_registration_setting: course_registration_setting)
  end

  def update(conn, %{"id" => id, "course_registration_setting" => course_registration_setting_params}) do
    course_registration_setting = Repo.get!(CourseRegistrationSetting, id)
    changeset = CourseRegistrationSetting.changeset(course_registration_setting, course_registration_setting_params)

    case Repo.update(changeset) do
      {:ok, course_registration_setting} ->
        course_registration_setting = course_registration_setting |> Repo.preload(CourseRegistrationSetting.associations)
        render(conn, "show.json", course_registration_setting: course_registration_setting)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PortalApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    course_registration_setting = Repo.get!(CourseRegistrationSetting, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(course_registration_setting)

    send_resp(conn, :no_content, "")
  end
  defp build_filters(query, [{"program_id", program_id} | tail]) do
    query
    |> Ecto.Query.where([crs], crs.program_id == ^program_id)
    |> build_filters(tail)
  end
  defp build_filters(query, [{"academic_session_id", academic_session_id} | tail]) do
    query
    |> Ecto.Query.where([crs], crs.academic_session_id == ^academic_session_id)
    |> build_filters(tail)
  end
  defp build_filters(query, []), do: query
  defp build_filters(query, [_ | tail]), do: query


  
end
