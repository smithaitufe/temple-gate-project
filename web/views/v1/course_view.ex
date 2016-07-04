defmodule PortalApi.V1.CourseView do
  use PortalApi.Web, :view

  def render("index.json", %{courses: courses}) do
    %{data: render_many(courses, PortalApi.V1.CourseView, "course.json")}
  end

  def render("show.json", %{course: course}) do
    %{data: render_one(course, PortalApi.V1.CourseView, "course.json")}
  end

  def render("course.json", %{course: course}) do
    %{id: course.id,
      department_id: course.department_id,
      level_id: course.level_id,
      semester_id: course.semester_id,
      code: course.code,
      title: course.title,
      units: course.units,
      hours: course.hours,
      core: course.core,
      description: course.description}
  end
end
