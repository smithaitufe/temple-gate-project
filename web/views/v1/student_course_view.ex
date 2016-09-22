defmodule PortalApi.V1.StudentCourseView do
  use PortalApi.Web, :view
  alias PortalApi.V1.{StudentCourseView, StudentView, CourseView, StudentCourseGradingView, StudentCourseAssessmentView}

  def render("index.json", %{student_courses: student_courses}) do
    render_many(student_courses, StudentCourseView, "student_course.json")
  end

  def render("show.json", %{student_course: student_course}) do
    render_one(student_course, StudentCourseView, "student_course.json")
  end

  def render("student_course.json", %{student_course: student_course}) do
    %{id: student_course.id,
      course_id: student_course.course_id,
      student_id: student_course.student_id,
      academic_session_id: student_course.academic_session_id,
      graded: student_course.graded
    }

    |> Map.put(:student, render_one(student_course.student, StudentView, "student_lite.json"))
    |> Map.put(:course, render_one(student_course.course, CourseView, "course.json"))    
    |> Map.put(:course_grade, render_one(student_course.course_grading, StudentCourseGradingView, "student_course_grading.json"))
    |> Map.put(:assessments, render_many(student_course.assessments, StudentCourseAssessmentView, "student_course_assessment.json"))
  end





end
