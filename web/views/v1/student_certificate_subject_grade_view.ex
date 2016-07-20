defmodule PortalApi.V1.StudentCertificateSubjectGradeView do
  use PortalApi.Web, :view

  def render("index.json", %{student_certificate_subject_grades: student_certificate_subject_grades}) do
    %{data: render_many(student_certificate_subject_grades, PortalApi.V1.StudentCertificateSubjectGradeView, "student_certificate_subject_grade.json")}
  end

  def render("show.json", %{student_certificate_subject_grade: student_certificate_subject_grade}) do
    %{data: render_one(student_certificate_subject_grade, PortalApi.V1.StudentCertificateSubjectGradeView, "student_certificate_subject_grade.json")}
  end

  def render("student_certificate_subject_grade.json", %{student_certificate_subject_grade: student_certificate_subject_grade}) do
    %{id: student_certificate_subject_grade.id,
      student_certificate_id: student_certificate_subject_grade.student_certificate_id,
      subject_id: student_certificate_subject_grade.subject_id,
      grade_id: student_certificate_subject_grade.grade_id}
  end
end
