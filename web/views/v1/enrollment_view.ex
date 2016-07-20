defmodule PortalApi.V1.EnrollmentView do
  use PortalApi.Web, :view
  alias PortalApi.V1.EnrollmentView

  def render("index.json", %{"enrollments" => enrollments}) do
    %{data: render_many(enrollments, EnrollmentView, "enrollment.json" )}
  end


  def render("enrollment.json", %{"enrollment" => enrollment}) do
    %{
      student: enrollment.student,
      course: enrollment.course_id,
    }
  end
end
