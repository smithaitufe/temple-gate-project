defmodule PortalApi.V1.StudentJambRecordView do
  use PortalApi.Web, :view

  def render("index.json", %{student_jamb_records: student_jamb_records}) do
    render_many(student_jamb_records, PortalApi.V1.StudentJambRecordView, "student_jamb_record.json")
  end

  def render("show.json", %{student_jamb_record: student_jamb_record}) do
    render_one(student_jamb_record, PortalApi.V1.StudentJambRecordView, "student_jamb_record.json")
  end

  def render("student_jamb_record.json", %{student_jamb_record: student_jamb_record}) do
    %{id: student_jamb_record.id,
      student_id: student_jamb_record.student_id,
      score: student_jamb_record.score,
      registration_no: student_jamb_record.registration_no}
  end
end
