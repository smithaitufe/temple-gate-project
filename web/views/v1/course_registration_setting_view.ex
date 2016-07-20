defmodule PortalApi.V1.CourseRegistrationSettingView do
  use PortalApi.Web, :view

  def render("index.json", %{course_registration_settings: course_registration_settings}) do
    %{data: render_many(course_registration_settings, PortalApi.V1.CourseRegistrationSettingView, "course_registration_setting.json")}
  end

  def render("show.json", %{course_registration_setting: course_registration_setting}) do
    %{data: render_one(course_registration_setting, PortalApi.V1.CourseRegistrationSettingView, "course_registration_setting.json")}
  end

  def render("course_registration_setting.json", %{course_registration_setting: course_registration_setting}) do
    %{
      id: course_registration_setting.id,
      program_id: course_registration_setting.program_id,
      academic_session_id: course_registration_setting.academic_session_id,
      opening_date: course_registration_setting.opening_date,
      closing_date: course_registration_setting.closing_date
    }
    |> PortalApi.V1.ProgramView.render_program(%{program: course_registration_setting.program})
    |> PortalApi.V1.AcademicSessionView.render_academic_session(%{academic_session: course_registration_setting.academic_session})
  end


end
