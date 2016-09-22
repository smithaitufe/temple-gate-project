import Ecto.Query
alias PortalApi.{Repo, TermSet, Term, AcademicSession, Program, Level, Faculty,FacultyHead, Department, DepartmentHead, ProgramDepartment, Grade, Course, CourseRegistrationSetting, State, LocalGovernmentArea, Student, Role, User, UserRole, StudentCourse,StudentCourseAssessment,StudentCourseGrading, Fee, StudentPayment, TransactionResponse, Newsroom, ProgramAdvert, Job, JobPosting, SalaryGradeLevel, SalaryGradeStep, Staff, StaffPosting, CourseTutor, LeaveDuration, StaffLeaveRequest}

divider = ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
commit = fn(term_set, terms) ->
  for term <- terms do
    result = Term |> Repo.get_by([term_set_id: term_set.id, description: term.description])
    if result == nil do
      Repo.transaction fn ->
        term = Map.put(term, :term_set_id, term_set.id)
        changeset = Term.changeset(%Term{},term)
        if changeset.valid? do
          Repo.insert(changeset)
        end
      end
    end
  end
end
assign_role = fn %{user_name: user_name, role: role, default: default} ->
  role = Role |> Repo.get_by(name: role)
  user = Repo.get_by(User, [user_name: String.downcase(user_name)])
  IO.inspect("#{user.email} - #{role.slug}")
  %UserRole{}
  |> UserRole.changeset(%{user_id: user.id, role_id: role.id, default: default})
  |> Repo.insert()
end
staff_posting = fn(%{user: user, job_title: job_title, department_name: department_name, posted_date: posted_date, effective_date: effective_date}) ->
  staff = Repo.get_by(Staff, user_id: user.id)
  job = Repo.get_by(Job, title: job_title)
  department = Repo.get_by(Department, name: department_name)
  salary_grade_step = SalaryGradeStep
  |> Ecto.Query.join(:inner, [sgs], sgl in assoc(sgs, :salary_grade_level))
  |> Ecto.Query.join(:inner, [sgs, sgl], sst in assoc(sgl, :salary_structure_type))
  |> Ecto.Query.join(:inner, [sgs, sgl, sst], ts in assoc(sst, :term_set))
  |> Ecto.Query.where([sgs, sgl, sst, ts], sgl.description == ^"09" and sgs.description == ^"09" and sst.description == ^"CONPCASS" and ts.name == ^"salary_structure_type")
  |> Repo.all
  |> List.first

  %StaffPosting{}
  |> StaffPosting.changeset(%{staff_id: staff.id, department_id: department.id, salary_grade_step_id: salary_grade_step.id, job_id: job.id, active: true, posted_date: posted_date, effective_date: effective_date})
  |> Repo.insert()
end
assign_office_head = fn %{type: type, user: user, name: name, appointment_date: appointment_date, effective_date: effective_date, end_date: end_date, active: active} ->
  staff = Repo.get_by(Staff, user_id: user.id)
  params = %{staff_id: staff.id, appointment_date: appointment_date, effective_date: effective_date, end_date: end_date, active: active}
  case type do
    "faculty" ->
      faculty = Faculty |> Repo.get_by(name: name)
      %FacultyHead{} |> FacultyHead.changeset(Map.put(params, :faculty_id, faculty.id)) |> Repo.insert!()
    "department" ->
      department = Department |> Repo.get_by(name: name)
      %DepartmentHead{} |> DepartmentHead.changeset(Map.put(params, :department_id, department.id)) |> Repo.insert!()
    end
end
register_courses = fn (student) ->
  department = Repo.get_by(Department, [name: "Mechanical Engineering"])
  level = Repo.get_by(Level, description: "ND I")
  academic_session = Repo.get_by(AcademicSession, [description: "2016/2017", active: true])
  courses = Repo.all(from c in Course, where: c.level_id == ^level.id and c.department_id == ^department.id)
  for course <- courses do
    changeset = StudentCourse.changeset(%StudentCourse{}, %{course_id: course.id, student_id: student.id, academic_session_id: academic_session.id, level_id: level.id})
    if changeset.valid? do
      Repo.insert!(changeset)
    end
  end
end





term_sets = [
  %{ name: "country", display_name: "Country" },
  %{ name: "gender", display_name: "Gender" },
  %{ name: "marital_status", display_name: "Marital Status" },
  %{ name: "title", display_name: "Title" },
  %{ name: "salutation", display_name: "Salutation" },
  %{ name: "semester", display_name: "Semester" },
  %{ name: "subject", display_name: "Subject" },
  %{ name: "subject_grade", display_name: "Grade" },
  %{ name: "application_status", display_name: "Application Status" },
  %{ name: "certificate", display_name: "Certificate" },
  %{ name: "department_type", display_name: "Department Type" },
  %{ name: "faculty_type", display_name: "Faculty Type" },
  %{ name: "admission_status", display_name: "Admission Status" },
  %{ name: "examination_body", display_name: "Examination Body" },
  %{ name: "salary_structure_type", display_name: "Salary Structure Type" },
  %{ name: "allowance", display_name: "Allowance" },
  %{ name: "assessment_type", display_name: "Assessment Type" },
  %{ name: "user_category", display_name: "User Category" },
  %{ name: "fee_category", display_name: "Fee Category" },
  %{ name: "payment_method", display_name: "Payment Method" },
  %{ name: "entry_mode", display_name: "Entry Mode" },
  %{ name: "grade_change_request_reason", display_name: "Grade Change Request Reason" },
  %{ name: "leave_type", display_name: "Leave Type" },
  %{ name: "leave_track_type", display_name: "Leave Track Type" },
  %{ name: "course_category", display_name: "Course Category"}

]
for term_set <- term_sets do
  t = TermSet |> Repo.get_by(name: term_set.name)
  if t == nil do
    changeset = TermSet.changeset(%TermSet{}, term_set)
    if changeset.valid?, do: Repo.insert!(changeset)
  end
end

term_set = TermSet |> Repo.get_by(name: "country")
terms = [%{description: "Nigeria"}]
commit.(term_set, terms)


term_set = TermSet |> Repo.get_by(name: "gender")
terms = [
  %{description: "Female"},
  %{description: "Male"}
]
commit.(term_set, terms)

term_set = TermSet |> Repo.get_by(name: "marital_status")
terms = [
  %{description: "Single"},
  %{description: "Married"},
  %{description: "Divorced"},
  %{description: "Legally Separated"},
  %{description: "Widow"},
  %{description: "Widower"}
]
commit.(term_set, terms)

term_set = TermSet |> Repo.get_by(name: "salutation")
terms = [
  %{description: "Mr."},
  %{description: "Mrs."},
  %{description: "Ms"},
  %{description: "Miss"}
]
commit.(term_set, terms)

term_set = TermSet |> Repo.get_by(name: "subject_grade")
terms = [
  %{description: "A1"},
  %{description: "B2"},
  %{description: "B3"},
  %{description: "C4"},
  %{description: "C5"},
  %{description: "C6"},
  %{description: "D7"},
  %{description: "E8"},
  %{description: "F9"},
  %{description: "Awaiting"}
]
commit.(term_set, terms)

term_set = TermSet |> Repo.get_by(name: "subject")
terms = [
  %{description: "Agricultural Science"},
  %{description: "Basic Electricity"},
  %{description: "Biology"},
  %{description: "Building/Engineering Drawing"},
  %{description: "Chemistry"},
  %{description: "Christian Religious Studies"},
  %{description: "Commerce"},
  %{description: "Economics"},
  %{description: "English Language"},
  %{description: "Financial Accounting/Booking-Keeping & Accounts"},
  %{description: "Further Mathematics"},
  %{description: "Geography"},
  %{description: "Government"},
  %{description: "Hausa"},
  %{description: "History"},
  %{description: "Home Management"},
  %{description: "Igbo"},
  %{description: "Information and Communiccation Technology"},
  %{description: "Literature in English"},
  %{description: "Mathematics"},
  %{description: "Mechanical Engineering Craft Practice"},
  %{description: "Physics"},
  %{description: "Typewriting"},
  %{description: "Yoruba"}
]
commit.(term_set, terms)


term_set = TermSet |> Repo.get_by(name: "examination_body")
terms = [
  %{description: "WAEC"},
  %{description: "WAEC GCE"},
  %{description: "NECO"},
  %{description: "NECO GCE"},
  %{description: "NABTEB"}
]
commit.(term_set, terms)

term_set = TermSet |> Repo.get_by(name: "payment_method")
terms = [
  %{description: "WebPAY"},
  %{description: "Bank"}
]
commit.(term_set, terms)



term_set = TermSet |> Repo.get_by(name: "semester")
terms = [
  %{description: "1st"},
  %{description: "2nd"}
]
commit.(term_set, terms)

term_set = TermSet |> Repo.get_by(name: "certificate")
terms = [
  %{description: "PSLC"},
  %{description: "WAEC"},
  %{description: "WAEC GCE"},
  %{description: "NECO"},
  %{description: "NECO GCE"},
  %{description: "ND"},
  %{description: "NCE"},
  %{description: "HND"},
  %{description: "BA"},
  %{description: "BSc"},
  %{description: "BEng"},
  %{description: "BTech"},
  %{description: "BEd"},
  %{description: "MA"},
  %{description: "MSc"},
  %{description: "MEng"},
  %{description: "MFA"},
  %{description: "LLM"},
  %{description: "MArch"},
  %{description: "MPhil"},
  %{description: "MBA"},
  %{description: "PhD"}
]
commit.(term_set, terms)

term_set = TermSet |> Repo.get_by(name: "application_status")
terms = [
  %{description: "Pending"},
  %{description: "Completed"}
]
commit.(term_set, terms)

term_set = TermSet |> Repo.get_by(name: "faculty_type")
terms = [
  %{description: "Academic"},
  %{description: "Non Academic"}
]
commit.(term_set, terms)

term_set = TermSet |> Repo.get_by(name: "department_type")
terms = [
  %{description: "Academic"},
  %{description: "Non Academic"}
]
commit.(term_set, terms)



term_set = TermSet |> Repo.get_by(name: "salary_structure_type")
terms =[
  %{description: "CONPCASS"},
  %{description: "CONTEDISS"}
]
commit.(term_set, terms)

term_set = TermSet |> Repo.get_by(name: "user_category")
terms =[
  %{description: "Applicant"},
  %{description: "Student"},
  %{description: "Staff"}
]
commit.(term_set, terms)

term_set = TermSet |> Repo.get_by(name: "assessment_type")
terms =[
  %{description: "Assignment"},
  %{description: "Class Work"},
  %{description: "Practical"},
  %{description: "Test"},
  %{description: "Examination"}
]
commit.(term_set, terms)

term_set = TermSet |> Repo.get_by(name: "grade_change_request_reason")
terms =[
  %{description: "Instructor error"},
  %{description: "Misevaluation of an exam"},
  %{description: "Miscalculation of student average"},
  %{description: "Error in grading several assignments"},
  %{description: "Mixup in my grading book"}
]
commit.(term_set, terms)

term_set = TermSet |> Repo.get_by(name: "leave_type")
terms =[
  %{description: "Maternity Leave"},
  %{description: "Overtime Leave"},
  %{description: "Annual Leave"},
  %{description: "Sick Leave"},
  %{description: "Adoptive Leave"},
  %{description: "Career Leave"}
]
commit.(term_set, terms)

term_set = TermSet |> Repo.get_by(name: "leave_track_type")
terms =[
  %{description: "Days"},
  %{description: "Months"}
]
commit.(term_set, terms)

term_set = TermSet |> Repo.get_by(name: "course_category")
terms =[
  %{description: "Core"},
  %{description: "GNS"},
  %{description: "Elective"},
]
commit.(term_set, terms)



[
  %{name: "Admin", description: "Administration"},
  %{name: "Registry", description: "Registry"},
  %{name: "RegistryAssist", description: "Registry Assistant"},
  %{name: "RegistryOfficer", description: "Registry Officer"},
  %{name: "FacultyHead", description: "Head of Faculty"},
  %{name: "DepartmentHead", description: "Head of Department"},
  %{name: "Lecturer", description: "Lecturer"},
  %{name: "Bursar", description: "Bursar"},
  %{name: "Account", description: "Account"},
  %{name: "Student", description: "Student"},
  %{name: "Applicant", description: "Applicant"}

]
|> Enum.each(&(
%Role{}
|> Role.changeset(&1)
|> Repo.insert()
))





term_set = TermSet |> Repo.get_by(name: "fee_category")
terms =[
  %{description: "Applicant"},
  %{description: "Student"}
]
commit.(term_set, terms)



term_set = TermSet |> Repo.get_by(name: "allowance")
terms = [
  %{description: "House"},
  %{description: "Leave"},
  %{description: "Transport"},
  %{description: "Utility"},
  %{description: "Meal"},
  %{description: "Furniture"},
  %{description: "Hazzard"},
  %{description: "Field"},
  %{description: "Overtime"}
]
commit.(term_set, terms)

term_set = TermSet |> Repo.get_by(name: "entry_mode")
terms = [
  %{description: "Direct Entry"},
  %{description: "Post UTME"}
]
commit.(term_set, terms)



programs = [
  %{name: "ND", description: "National Diploma", duration: 2 }, %{name: "HND", description: "Higher National Diploma", duration: 2 }
]
for program <- programs do
  if(Repo.get_by(Program, [name: program[:name]]) == nil) do
    changeset = Program.changeset(%Program{}, program)
    if changeset.valid?, do: Repo.insert!(changeset)
  end
end

program = Repo.get_by(Program, [name: "ND"])
levels = [%{description: "ND I", program_id: program.id}, %{description: "ND II", program_id: program.id}]
for level <- levels do
  if(Repo.get_by(Level, [description: level[:description]]) == nil) do
    changeset = Level.changeset(%Level{}, level)
    if changeset.valid?, do: Repo.insert!(changeset)
  end
end

program = Repo.get_by(Program, [name: "HND"])
levels = [%{description: "HND I", program_id: program.id}, %{description: "HND II", program_id: program.id}]
for level <- levels do
  if(Repo.get_by(Level, [description: level[:description]]) == nil) do
    changeset = Level.changeset(%Level{}, level)
    if changeset.valid?, do: Repo.insert!(changeset)
  end
end



states =[
  %{name: "Abia"},
  %{name: "Adamawa"},
  %{name: "Akwa Ibom"},
  %{name: "Anambra"},
  %{name: "Bauchi"},
  %{name: "Bayelsa"},
  %{name: "Benue"},
  %{name: "Bornu"},
  %{name: "Cross River"},
  %{name: "Delta"},
  %{name: "Ebonyi"},
  %{name: "Edo"},
  %{name: "Ekiti"},
  %{name: "Enugu"},
  %{name: "FCT"},
  %{name: "Gombe"},
  %{name: "Imo"},
  %{name: "Jigawa"},
  %{name: "Kaduna"},
  %{name: "Kano"},
  %{name: "Katsina"},
  %{name: "Kebbi"},
  %{name: "Kogi"},
  %{name: "Kwara"},
  %{name: "Lagos"},
  %{name: "Nasarawa"},
  %{name: "Niger"},
  %{name: "Ogun"},
  %{name: "Ondo"},
  %{name: "Osun"},
  %{name: "Oyo"},
  %{name: "Plateau"},
  %{name: "Rivers"},
  %{name: "Sokoto"},
  %{name: "Taraba"},
  %{name: "Yobe"},
  %{name: "Zamfara"}
]
country = Repo.get_by(Term, [description: "Nigeria"])
for s <- states do
  Repo.transaction fn ->

    if Repo.get_by(State, [country_id: country.id, name: s.name]) == nil do
      state_params = Map.put(s, :country_id, country.id)
      changeset = State.changeset(%State{}, state_params)
      if changeset.valid?, do: Repo.insert(changeset)
    end
  end
end


local_government_areas =[
  %{name: "Aba North", state: "Abia"},
  %{name: "Aba South", state: "Abia"},
  %{name: "Arochukwu", state: "Abia"},
  %{name: "Bende", state: "Abia"},
  %{name: "Ikwuano", state: "Abia"},
  %{name: "Isiala-Ngwa North", state: "Abia"},
  %{name: "Isiala-Ngwa South", state: "Abia"},
  %{name: "Isuikwato", state: "Abia"},
  %{name: "Obi Nwa", state: "Abia"},
  %{name: "Ohafia", state: "Abia"},
  %{name: "Osisioma", state: "Abia"},
  %{name: "Ngwa", state: "Abia"},
  %{name: "Ugwunagbo", state: "Abia"},
  %{name: "Ukwa East", state: "Abia"},
  %{name: "Ukwa West", state: "Abia"},
  %{name: "Umuahia North", state: "Abia"},
  %{name: "Umuahia South", state: "Abia"},
  %{name: "Umu-Neochi", state: "Abia"},
  %{name: "Demsa", state: "Adamawa"},
  %{name: "Fufore", state: "Adamawa"},
  %{name: "Ganaye", state: "Adamawa"},
  %{name: "Gireri", state: "Adamawa"},
  %{name: "Gombi", state: "Adamawa"},
  %{name: "Guyuk", state: "Adamawa"},
  %{name: "Hong", state: "Adamawa"},
  %{name: "Jada", state: "Adamawa"},
  %{name: "Lamurde", state: "Adamawa"},
  %{name: "Madagali", state: "Adamawa"},
  %{name: "Maiha", state: "Adamawa"},
  %{name: "Mayo-Belwa", state: "Adamawa"},
  %{name: "Michika", state: "Adamawa"},
  %{name: "Mubi North", state: "Adamawa"},
  %{name: "Mubi South", state: "Adamawa"},
  %{name: "Numan", state: "Adamawa"},
  %{name: "Shelleng", state: "Adamawa"},
  %{name: "Song", state: "Adamawa"},
  %{name: "Toungo", state: "Adamawa"},
  %{name: "Yola North", state: "Adamawa"},
  %{name: "Yola South", state: "Adamawa"},
  %{name: "Abak", state: "Akwa Ibom"},
  %{name: "Eastern Obolo", state: "Akwa Ibom"},
  %{name: "Eket", state: "Akwa Ibom"},
  %{name: "Esit Eket", state: "Akwa Ibom"},
  %{name: "Essien Udim", state: "Akwa Ibom"},
  %{name: "Etim Ekpo", state: "Akwa Ibom"},
  %{name: "Etinan", state: "Akwa Ibom"},
  %{name: "Ibeno", state: "Akwa Ibom"},
  %{name: "Ibesikpo Asutan", state: "Akwa Ibom"},
  %{name: "Ibiono Ibom", state: "Akwa Ibom"},
  %{name: "Ika", state: "Akwa Ibom"},
  %{name: "Ikono", state: "Akwa Ibom"},
  %{name: "Ikot Abasi", state: "Akwa Ibom"},
  %{name: "Ikot Ekpene", state: "Akwa Ibom"},
  %{name: "Ini", state: "Akwa Ibom"},
  %{name: "Itu", state: "Akwa Ibom"},
  %{name: "Mbo", state: "Akwa Ibom"},
  %{name: "Mkpat Enin", state: "Akwa Ibom"},
  %{name: "Nsit Atai", state: "Akwa Ibom"},
  %{name: "Nsit Ibom", state: "Akwa Ibom"},
  %{name: "Nsit Ubium", state: "Akwa Ibom"},
  %{name: "Obot Akara", state: "Akwa Ibom"},
  %{name: "Okobo", state: "Akwa Ibom"},
  %{name: "Onna", state: "Akwa Ibom"},
  %{name: "Oron", state: "Akwa Ibom"},
  %{name: "Oruk Anam", state: "Akwa Ibom"},
  %{name: "Udung Uko", state: "Akwa Ibom"},
  %{name: "Ukanafun", state: "Akwa Ibom"},
  %{name: "Uruan", state: "Akwa Ibom"},
  %{name: "Urue-Offong/Oruko", state: "Akwa Ibom"},
  %{name: "Uyo", state: "Akwa Ibom"},
  %{name: "Aguata", state: "Anambra"},
  %{name: "Anambra East", state: "Anambra"},
  %{name: "Anambra West", state: "Anambra"},
  %{name: "Anaocha", state: "Anambra"},
  %{name: "Awka North", state: "Anambra"},
  %{name: "Awka South", state: "Anambra"},
  %{name: "Ayamelum", state: "Anambra"},
  %{name: "Dunukofia", state: "Anambra"},
  %{name: "Ekwusigo", state: "Anambra"},
  %{name: "Idemili North", state: "Anambra"},
  %{name: "Idemili south", state: "Anambra"},
  %{name: "Ihiala", state: "Anambra"},
  %{name: "Njikoka", state: "Anambra"},
  %{name: "Nnewi North", state: "Anambra"},
  %{name: "Nnewi South", state: "Anambra"},
  %{name: "Ogbaru", state: "Anambra"},
  %{name: "Onitsha North", state: "Anambra"},
  %{name: "Onitsha South", state: "Anambra"},
  %{name: "Orumba North", state: "Anambra"},
  %{name: "Orumba South", state: "Anambra"},
  %{name: "Oyi", state: "Anambra"},
  %{name: "Alkaleri", state: "Bauchi"},
  %{name: "Bauchi", state: "Bauchi"},
  %{name: "Bogoro", state: "Bauchi"},
  %{name: "Damban", state: "Bauchi"},
  %{name: "Darazo", state: "Bauchi"},
  %{name: "Dass", state: "Bauchi"},
  %{name: "Ganjuwa", state: "Bauchi"},
  %{name: "Giade", state: "Bauchi"},
  %{name: "Itas/Gadau", state: "Bauchi"},
  %{name: "Jama'are", state: "Bauchi"},
  %{name: "Katagum", state: "Bauchi"},
  %{name: "Kirfi", state: "Bauchi"},
  %{name: "Misau", state: "Bauchi"},
  %{name: "Ningi", state: "Bauchi"},
  %{name: "Shira", state: "Bauchi"},
  %{name: "Tafawa-Balewa", state: "Bauchi"},
  %{name: "Toro", state: "Bauchi"},
  %{name: "Warji", state: "Bauchi"},
  %{name: "Zaki", state: "Bauchi"},
  %{name: "Brass", state: "Bayelsa"},
  %{name: "Ekeremor", state: "Bayelsa"},
  %{name: "Kolokuma/Opokuma", state: "Bayelsa"},
  %{name: "Nembe", state: "Bayelsa"},
  %{name: "Ogbia", state: "Bayelsa"},
  %{name: "Sagbama", state: "Bayelsa"},
  %{name: "Southern Jaw", state: "Bayelsa"},
  %{name: "Yenegoa", state: "Bayelsa"},
  %{name: "Ado", state: "Benue"},
  %{name: "Agatu", state: "Benue"},
  %{name: "Apa", state: "Benue"},
  %{name: "Buruku", state: "Benue"},
  %{name: "Gboko", state: "Benue"},
  %{name: "Guma", state: "Benue"},
  %{name: "Gwer East", state: "Benue"},
  %{name: "Gwer West", state: "Benue"},
  %{name: "Katsina-Ala", state: "Benue"},
  %{name: "Konshisha", state: "Benue"},
  %{name: "Kwande", state: "Benue"},
  %{name: "Logo", state: "Benue"},
  %{name: "Makurdi", state: "Benue"},
  %{name: "Obi", state: "Benue"},
  %{name: "Ogbadibo", state: "Benue"},
  %{name: "Oju", state: "Benue"},
  %{name: "Okpokwu", state: "Benue"},
  %{name: "Ohimini", state: "Benue"},
  %{name: "Oturkpo", state: "Benue"},
  %{name: "Tarka", state: "Benue"},
  %{name: "Ukum", state: "Benue"},
  %{name: "Ushongo", state: "Benue"},
  %{name: "Vandeikya", state: "Benue"},
  %{name: "Abadam", state: "Bornu"},
  %{name: "Askira/Uba", state: "Bornu"},
  %{name: "Bama", state: "Bornu"},
  %{name: "Bayo", state: "Bornu"},
  %{name: "Biu", state: "Bornu"},
  %{name: "Chibok", state: "Bornu"},
  %{name: "Damboa", state: "Bornu"},
  %{name: "Dikwa", state: "Bornu"},
  %{name: "Gubio", state: "Bornu"},
  %{name: "Guzamala", state: "Bornu"},
  %{name: "Gwoza", state: "Bornu"},
  %{name: "Hawul", state: "Bornu"},
  %{name: "Jere", state: "Bornu"},
  %{name: "Kaga", state: "Bornu"},
  %{name: "Kala/Balge", state: "Bornu"},
  %{name: "Konduga", state: "Bornu"},
  %{name: "Kukawa", state: "Bornu"},
  %{name: "Kwaya Kusar", state: "Bornu"},
  %{name: "Mafa", state: "Bornu"},
  %{name: "Magumeri", state: "Bornu"},
  %{name: "Maiduguri", state: "Bornu"},
  %{name: "Marte", state: "Bornu"},
  %{name: "Mobbar", state: "Bornu"},
  %{name: "Monguno", state: "Bornu"},
  %{name: "Ngala", state: "Bornu"},
  %{name: "Nganzai", state: "Bornu"},
  %{name: "Shani", state: "Bornu"},
  %{name: "Akpabuyo", state: "Cross River"},
  %{name: "Odukpani", state: "Cross River"},
  %{name: "Akamkpa", state: "Cross River"},
  %{name: "Biase", state: "Cross River"},
  %{name: "Abi", state: "Cross River"},
  %{name: "Ikom", state: "Cross River"},
  %{name: "Yarkur", state: "Cross River"},
  %{name: "Odubra", state: "Cross River"},
  %{name: "Boki", state: "Cross River"},
  %{name: "Ogoja", state: "Cross River"},
  %{name: "Yala", state: "Cross River"},
  %{name: "Obanliku", state: "Cross River"},
  %{name: "Obudu", state: "Cross River"},
  %{name: "Calabar South", state: "Cross River"},
  %{name: "Etung", state: "Cross River"},
  %{name: "Bekwara", state: "Cross River"},
  %{name: "Bakassi", state: "Cross River"},
  %{name: "Calabar Municipality", state: "Cross River"},
  %{name: "Oshimili South", state: "Delta"},
  %{name: "Aniocha North", state: "Delta"},
  %{name: "Aniocha South", state: "Delta"},
  %{name: "Ika South", state: "Delta"},
  %{name: "Ika North-East", state: "Delta"},
  %{name: "Ndokwa West", state: "Delta"},
  %{name: "Ndokwa East", state: "Delta"},
  %{name: "Isoko South", state: "Delta"},
  %{name: "Isoko North", state: "Delta"},
  %{name: "Bomadi", state: "Delta"},
  %{name: "Burutu", state: "Delta"},
  %{name: "Ughelli South", state: "Delta"},
  %{name: "Ughelli North", state: "Delta"},
  %{name: "Ethiope West", state: "Delta"},
  %{name: "Ethiope East", state: "Delta"},
  %{name: "Sapele", state: "Delta"},
  %{name: "Okpe", state: "Delta"},
  %{name: "Warri North", state: "Delta"},
  %{name: "Warri South", state: "Delta"},
  %{name: "Uvwie", state: "Delta"},
  %{name: "Udu", state: "Delta"},
  %{name: "Warri Central", state: "Delta"},
  %{name: "Ukwani", state: "Delta"},
  %{name: "Oshimili North", state: "Delta"},
  %{name: "Patani", state: "Delta"},
  %{name: "Afikpo South", state: "Ebonyi"},
  %{name: "Afikpo North", state: "Ebonyi"},
  %{name: "Onicha", state: "Ebonyi"},
  %{name: "Ohaozara", state: "Ebonyi"},
  %{name: "Abakaliki", state: "Ebonyi"},
  %{name: "Ishielu", state: "Ebonyi"},
  %{name: "lkwo", state: "Ebonyi"},
  %{name: "Ezza", state: "Ebonyi"},
  %{name: "Ezza South", state: "Ebonyi"},
  %{name: "Ohaukwu", state: "Ebonyi"},
  %{name: "Ebonyi", state: "Ebonyi"},
  %{name: "Ivo", state: "Ebonyi"},
  %{name: "Esan North-East", state: "Edo"},
  %{name: "Esan Central", state: "Edo"},
  %{name: "Esan West", state: "Edo"},
  %{name: "Egor", state: "Edo"},
  %{name: "Ukpoba", state: "Edo"},
  %{name: "Central", state: "Edo"},
  %{name: "Etsako Central", state: "Edo"},
  %{name: "Igueben", state: "Edo"},
  %{name: "Oredo", state: "Edo"},
  %{name: "Ovia SouthWest", state: "Edo"},
  %{name: "Ovia South-East", state: "Edo"},
  %{name: "Orhionwon", state: "Edo"},
  %{name: "Uhunmwonde", state: "Edo"},
  %{name: "Etsako East", state: "Edo"},
  %{name: "Esan South-East", state: "Edo"},
  %{name: "Ado", state: "Ekiti"},
  %{name: "Ekiti-East", state: "Ekiti"},
  %{name: "Ekiti-West", state: "Ekiti"},
  %{name: "Emure/Ise/Orun", state: "Ekiti"},
  %{name: "Ekiti South-West", state: "Ekiti"},
  %{name: "Ikare", state: "Ekiti"},
  %{name: "Irepodun", state: "Ekiti"},
  %{name: "Ijero,", state: "Ekiti"},
  %{name: "Ido/Osi", state: "Ekiti"},
  %{name: "Oye", state: "Ekiti"},
  %{name: "Ikole", state: "Ekiti"},
  %{name: "Moba", state: "Ekiti"},
  %{name: "Gbonyin", state: "Ekiti"},
  %{name: "Efon", state: "Ekiti"},
  %{name: "Ise/Orun", state: "Ekiti"},
  %{name: "Ilejemeje", state: "Ekiti"},
  %{name: "Enugu South,", state: "Enugu"},
  %{name: "Igbo-Eze South", state: "Enugu"},
  %{name: "Enugu North", state: "Enugu"},
  %{name: "Nkanu", state: "Enugu"},
  %{name: "Udi Agwu", state: "Enugu"},
  %{name: "Oji-River", state: "Enugu"},
  %{name: "Ezeagu", state: "Enugu"},
  %{name: "IgboEze North", state: "Enugu"},
  %{name: "Isi-Uzo", state: "Enugu"},
  %{name: "Nsukka", state: "Enugu"},
  %{name: "Igbo-Ekiti", state: "Enugu"},
  %{name: "Uzo-Uwani", state: "Enugu"},
  %{name: "Enugu Eas", state: "Enugu"},
  %{name: "Aninri", state: "Enugu"},
  %{name: "Nkanu East", state: "Enugu"},
  %{name: "Udenu", state: "Enugu"},
  %{name: "Awgu", state: "Enugu"},
  %{name: "Gwagwalada", state: "FCT"},
  %{name: "Kuje", state: "FCT"},
  %{name: "Abaji", state: "FCT"},
  %{name: "Abuja Municipal", state: "FCT"},
  %{name: "Bwari", state: "FCT"},
  %{name: "Kwali", state: "FCT"},
  %{name: "Akko", state: "Gombe"},
  %{name: "Balanga", state: "Gombe"},
  %{name: "Billiri", state: "Gombe"},
  %{name: "Dukku", state: "Gombe"},
  %{name: "Kaltungo", state: "Gombe"},
  %{name: "Kwami", state: "Gombe"},
  %{name: "Shomgom", state: "Gombe"},
  %{name: "Funakaye", state: "Gombe"},
  %{name: "Gombe", state: "Gombe"},
  %{name: "Nafada/Bajoga", state: "Gombe"},
  %{name: "Yamaltu/Delta", state: "Gombe"},
  %{name: "Aboh-Mbaise", state: "Imo"},
  %{name: "Ahiazu-Mbaise", state: "Imo"},
  %{name: "Ehime-Mbano", state: "Imo"},
  %{name: "Ezinihitte", state: "Imo"},
  %{name: "Ideato North", state: "Imo"},
  %{name: "Ideato South", state: "Imo"},
  %{name: "Ihitte/Uboma", state: "Imo"},
  %{name: "Ikeduru", state: "Imo"},
  %{name: "Isiala Mbano", state: "Imo"},
  %{name: "Isu", state: "Imo"},
  %{name: "Mbaitoli", state: "Imo"},
  %{name: "Mbaitoli", state: "Imo"},
  %{name: "Ngor-Okpala", state: "Imo"},
  %{name: "Njaba", state: "Imo"},
  %{name: "Nwangele", state: "Imo"},
  %{name: "Nkwerre", state: "Imo"},
  %{name: "Obowo", state: "Imo"},
  %{name: "Oguta", state: "Imo"},
  %{name: "Ohaji/Egbema", state: "Imo"},
  %{name: "Okigwe", state: "Imo"},
  %{name: "Orlu", state: "Imo"},
  %{name: "Orsu", state: "Imo"},
  %{name: "Oru East", state: "Imo"},
  %{name: "Oru West", state: "Imo"},
  %{name: "Owerri-Municipal", state: "Imo"},
  %{name: "Owerri North", state: "Imo"},
  %{name: "Owerri West", state: "Imo"},
  %{name: "Auyo", state: "Jigawa"},
  %{name: "Babura", state: "Jigawa"},
  %{name: "Birni Kudu", state: "Jigawa"},
  %{name: "Biriniwa", state: "Jigawa"},
  %{name: "Buji", state: "Jigawa"},
  %{name: "Dutse", state: "Jigawa"},
  %{name: "Gagarawa", state: "Jigawa"},
  %{name: "Garki", state: "Jigawa"},
  %{name: "Gumel", state: "Jigawa"},
  %{name: "Guri", state: "Jigawa"},
  %{name: "Gwaram", state: "Jigawa"},
  %{name: "Gwiwa", state: "Jigawa"},
  %{name: "Hadejia", state: "Jigawa"},
  %{name: "Jahun", state: "Jigawa"},
  %{name: "Kafin Hausa", state: "Jigawa"},
  %{name: "Kaugama Kazaure", state: "Jigawa"},
  %{name: "Kiri Kasamma", state: "Jigawa"},
  %{name: "Kiyawa", state: "Jigawa"},
  %{name: "Maigatari", state: "Jigawa"},
  %{name: "Malam Madori", state: "Jigawa"},
  %{name: "Miga", state: "Jigawa"},
  %{name: "Ringim", state: "Jigawa"},
  %{name: "Roni", state: "Jigawa"},
  %{name: "Sule-Tankarkar", state: "Jigawa"},
  %{name: "Taura", state: "Jigawa"},
  %{name: "Yankwashi", state: "Jigawa"},
  %{name: "Birni-Gwari", state: "Kaduna"},
  %{name: "Chikun", state: "Kaduna"},
  %{name: "Giwa", state: "Kaduna"},
  %{name: "Igabi", state: "Kaduna"},
  %{name: "Ikara", state: "Kaduna"},
  %{name: "jaba", state: "Kaduna"},
  %{name: "Jema'a", state: "Kaduna"},
  %{name: "Kachia", state: "Kaduna"},
  %{name: "Kaduna North", state: "Kaduna"},
  %{name: "Kaduna South", state: "Kaduna"},
  %{name: "Kagarko", state: "Kaduna"},
  %{name: "Kajuru", state: "Kaduna"},
  %{name: "Kaura", state: "Kaduna"},
  %{name: "Kauru", state: "Kaduna"},
  %{name: "Kubau", state: "Kaduna"},
  %{name: "Kudan", state: "Kaduna"},
  %{name: "Lere", state: "Kaduna"},
  %{name: "Makarfi", state: "Kaduna"},
  %{name: "Sabon-Gari", state: "Kaduna"},
  %{name: "Sanga", state: "Kaduna"},
  %{name: "Soba", state: "Kaduna"},
  %{name: "Zango-Kataf", state: "Kaduna"},
  %{name: "Zaria", state: "Kaduna"},
  %{name: "Ajingi", state: "Kano"},
  %{name: "Albasu", state: "Kano"},
  %{name: "Bagwai", state: "Kano"},
  %{name: "Bebeji", state: "Kano"},
  %{name: "Bichi", state: "Kano"},
  %{name: "Bunkure", state: "Kano"},
  %{name: "Dala", state: "Kano"},
  %{name: "Dambatta", state: "Kano"},
  %{name: "Dawakin Kudu", state: "Kano"},
  %{name: "Dawakin Tofa", state: "Kano"},
  %{name: "Doguwa", state: "Kano"},
  %{name: "Fagge", state: "Kano"},
  %{name: "Gabasawa", state: "Kano"},
  %{name: "Garko", state: "Kano"},
  %{name: "Garum", state: "Kano"},
  %{name: "Mallam", state: "Kano"},
  %{name: "Gaya", state: "Kano"},
  %{name: "Gezawa", state: "Kano"},
  %{name: "Gwale", state: "Kano"},
  %{name: "Gwarzo", state: "Kano"},
  %{name: "Kabo", state: "Kano"},
  %{name: "Kano Municipal", state: "Kano"},
  %{name: "Karaye", state: "Kano"},
  %{name: "Kibiya", state: "Kano"},
  %{name: "Kiru", state: "Kano"},
  %{name: "kumbotso", state: "Kano"},
  %{name: "Kunchi", state: "Kano"},
  %{name: "Kura", state: "Kano"},
  %{name: "Madobi", state: "Kano"},
  %{name: "Makoda", state: "Kano"},
  %{name: "Minjibir", state: "Kano"},
  %{name: "Nasarawa", state: "Kano"},
  %{name: "Rano", state: "Kano"},
  %{name: "Rimin Gado", state: "Kano"},
  %{name: "Rogo", state: "Kano"},
  %{name: "Shanono", state: "Kano"},
  %{name: "Sumaila", state: "Kano"},
  %{name: "Takali", state: "Kano"},
  %{name: "Tarauni", state: "Kano"},
  %{name: "Tofa", state: "Kano"},
  %{name: "Tsanyawa", state: "Kano"},
  %{name: "Tudun Wada", state: "Kano"},
  %{name: "Ungogo", state: "Kano"},
  %{name: "Warawa", state: "Kano"},
  %{name: "Wudil", state: "Kano"},
  %{name: "Bakori", state: "Katsina"},
  %{name: "Batagarawa", state: "Katsina"},
  %{name: "Batsari", state: "Katsina"},
  %{name: "Baure", state: "Katsina"},
  %{name: "Bindawa", state: "Katsina"},
  %{name: "Charanchi", state: "Katsina"},
  %{name: "Dandume", state: "Katsina"},
  %{name: "Danja", state: "Katsina"},
  %{name: "Dan Musa", state: "Katsina"},
  %{name: "Daura", state: "Katsina"},
  %{name: "Dutsi", state: "Katsina"},
  %{name: "Dutsin-Ma", state: "Katsina"},
  %{name: "Faskari", state: "Katsina"},
  %{name: "Funtua", state: "Katsina"},
  %{name: "Ingawa", state: "Katsina"},
  %{name: "Jibia", state: "Katsina"},
  %{name: "Kafur", state: "Katsina"},
  %{name: "Kaita", state: "Katsina"},
  %{name: "Kankara", state: "Katsina"},
  %{name: "Kankia", state: "Katsina"},
  %{name: "Katsina", state: "Katsina"},
  %{name: "Kurfi", state: "Katsina"},
  %{name: "Kusada", state: "Katsina"},
  %{name: "Mai'Adua", state: "Katsina"},
  %{name: "Malumfashi", state: "Katsina"},
  %{name: "Mani", state: "Katsina"},
  %{name: "Mashi", state: "Katsina"},
  %{name: "Matazuu", state: "Katsina"},
  %{name: "Musawa", state: "Katsina"},
  %{name: "Rimi", state: "Katsina"},
  %{name: "Sabuwa", state: "Katsina"},
  %{name: "Safana", state: "Katsina"},
  %{name: "Sandamu", state: "Katsina"},
  %{name: "Zango", state: "Katsina"},
  %{name: "Aleiro", state: "Kebbi"},
  %{name: "Arewa-Dandi", state: "Kebbi"},
  %{name: "Argungu", state: "Kebbi"},
  %{name: "Augie", state: "Kebbi"},
  %{name: "Bagudo", state: "Kebbi"},
  %{name: "Birnin Kebbi", state: "Kebbi"},
  %{name: "Bunza", state: "Kebbi"},
  %{name: "Dandi", state: "Kebbi"},
  %{name: "Fakai", state: "Kebbi"},
  %{name: "Gwandu", state: "Kebbi"},
  %{name: "Jega", state: "Kebbi"},
  %{name: "Kalgo", state: "Kebbi"},
  %{name: "Koko/Besse", state: "Kebbi"},
  %{name: "Maiyama", state: "Kebbi"},
  %{name: "Ngaski", state: "Kebbi"},
  %{name: "Sakaba", state: "Kebbi"},
  %{name: "Shanga", state: "Kebbi"},
  %{name: "Suru", state: "Kebbi"},
  %{name: "Wasagu/Danko", state: "Kebbi"},
  %{name: "Yauri", state: "Kebbi"},
  %{name: "Zuru", state: "Kebbi"},
  %{name: "Adavi", state: "Kogi"},
  %{name: "Ajaokuta", state: "Kogi"},
  %{name: "Ankpa", state: "Kogi"},
  %{name: "Bassa", state: "Kogi"},
  %{name: "Dekina", state: "Kogi"},
  %{name: "Ibaji", state: "Kogi"},
  %{name: "Idah", state: "Kogi"},
  %{name: "Igalamela-Odolu", state: "Kogi"},
  %{name: "Ijumu", state: "Kogi"},
  %{name: "Kabba/Bunu", state: "Kogi"},
  %{name: "Kogi", state: "Kogi"},
  %{name: "Lokoja", state: "Kogi"},
  %{name: "Mopa-Muro", state: "Kogi"},
  %{name: "Ofu", state: "Kogi"},
  %{name: "Ogori/Mangongo", state: "Kogi"},
  %{name: "Okehi", state: "Kogi"},
  %{name: "Okene", state: "Kogi"},
  %{name: "Olamabolo", state: "Kogi"},
  %{name: "Omala", state: "Kogi"},
  %{name: "Yagba East", state: "Kogi"},
  %{name: "Yagba West", state: "Kogi"},
  %{name: "Asa", state: "Kwara"},
  %{name: "Baruten", state: "Kwara"},
  %{name: "Edu", state: "Kwara"},
  %{name: "Ekiti", state: "Kwara"},
  %{name: "Ifelodun", state: "Kwara"},
  %{name: "Ilorin East", state: "Kwara"},
  %{name: "Ilorin West", state: "Kwara"},
  %{name: "Irepodun", state: "Kwara"},
  %{name: "Isin", state: "Kwara"},
  %{name: "Kaiama", state: "Kwara"},
  %{name: "Moro", state: "Kwara"},
  %{name: "Offa", state: "Kwara"},
  %{name: "Oke-Ero", state: "Kwara"},
  %{name: "Oyun", state: "Kwara"},
  %{name: "Pategi", state: "Kwara"},
  %{name: "Agege", state: "Lagos"},
  %{name: "Ajeromi-Ifelodun", state: "Lagos"},
  %{name: "Alimosho", state: "Lagos"},
  %{name: "Amuwo-Odofin", state: "Lagos"},
  %{name: "Apapa", state: "Lagos"},
  %{name: "Badagry", state: "Lagos"},
  %{name: "Epe", state: "Lagos"},
  %{name: "Eti-Osa", state: "Lagos"},
  %{name: "Ibeju/Lekki", state: "Lagos"},
  %{name: "Ifako-Ijaye", state: "Lagos"},
  %{name: "Ikeja", state: "Lagos"},
  %{name: "Ikorodu", state: "Lagos"},
  %{name: "Kosofe", state: "Lagos"},
  %{name: "Lagos Island", state: "Lagos"},
  %{name: "Lagos Mainland", state: "Lagos"},
  %{name: "Mushin", state: "Lagos"},
  %{name: "Ojo", state: "Lagos"},
  %{name: "Oshodi-Isolo", state: "Lagos"},
  %{name: "Shomolu", state: "Lagos"},
  %{name: "Surulere", state: "Lagos"},
  %{name: "Akwanga", state: "Nasarawa"},
  %{name: "Awe", state: "Nasarawa"},
  %{name: "Doma", state: "Nasarawa"},
  %{name: "Karu", state: "Nasarawa"},
  %{name: "Keana", state: "Nasarawa"},
  %{name: "Keffi", state: "Nasarawa"},
  %{name: "Kokona", state: "Nasarawa"},
  %{name: "Lafia", state: "Nasarawa"},
  %{name: "Nasarawa", state: "Nasarawa"},
  %{name: "Nasarawa-Eggon", state: "Nasarawa"},
  %{name: "Obi", state: "Nasarawa"},
  %{name: "Toto", state: "Nasarawa"},
  %{name: "Wamba", state: "Nasarawa"},
  %{name: "Agaie", state: "Niger"},
  %{name: "Agwara", state: "Niger"},
  %{name: "Bida", state: "Niger"},
  %{name: "Borgu", state: "Niger"},
  %{name: "Bosso", state: "Niger"},
  %{name: "Chanchaga", state: "Niger"},
  %{name: "Edati", state: "Niger"},
  %{name: "Gbako", state: "Niger"},
  %{name: "Gurara", state: "Niger"},
  %{name: "Katcha", state: "Niger"},
  %{name: "Kontagora", state: "Niger"},
  %{name: "Lapai", state: "Niger"},
  %{name: "Lavun", state: "Niger"},
  %{name: "Magama", state: "Niger"},
  %{name: "Mariga", state: "Niger"},
  %{name: "Mashegu", state: "Niger"},
  %{name: "Mokwa", state: "Niger"},
  %{name: "Muya", state: "Niger"},
  %{name: "Pailoro", state: "Niger"},
  %{name: "Rafi", state: "Niger"},
  %{name: "Rijau", state: "Niger"},
  %{name: "Shiroro", state: "Niger"},
  %{name: "Suleja", state: "Niger"},
  %{name: "Tafa", state: "Niger"},
  %{name: "Wushishi", state: "Niger"},
  %{name: "Abeokuta North", state: "Ogun"},
  %{name: "Abeokuta South", state: "Ogun"},
  %{name: "Ado-Odo/Ota", state: "Ogun"},
  %{name: "Egbado North", state: "Ogun"},
  %{name: "Egbado South", state: "Ogun"},
  %{name: "Ewekoro", state: "Ogun"},
  %{name: "Ifo", state: "Ogun"},
  %{name: "Ijebu East", state: "Ogun"},
  %{name: "Ijebu North", state: "Ogun"},
  %{name: "Ijebu North East", state: "Ogun"},
  %{name: "Ijebu Ode", state: "Ogun"},
  %{name: "Ikenne", state: "Ogun"},
  %{name: "Imeko-Afon", state: "Ogun"},
  %{name: "Ipokia", state: "Ogun"},
  %{name: "Obafemi-Owode", state: "Ogun"},
  %{name: "Ogun Waterside", state: "Ogun"},
  %{name: "Odeda", state: "Ogun"},
  %{name: "Odogbolu", state: "Ogun"},
  %{name: "Remo North", state: "Ogun"},
  %{name: "Shagamu", state: "Ogun"},
  %{name: "Akoko North East", state: "Ondo"},
  %{name: "Akoko North West", state: "Ondo"},
  %{name: "Akoko South Akure East", state: "Ondo"},
  %{name: "Akoko South West", state: "Ondo"},
  %{name: "Akure North", state: "Ondo"},
  %{name: "Akure South", state: "Ondo"},
  %{name: "Ese-Odo", state: "Ondo"},
  %{name: "Idanre", state: "Ondo"},
  %{name: "Ifedore", state: "Ondo"},
  %{name: "Ilaje", state: "Ondo"},
  %{name: "Ile-Oluji", state: "Ondo"},
  %{name: "Okeigbo", state: "Ondo"},
  %{name: "Irele", state: "Ondo"},
  %{name: "Odigbo", state: "Ondo"},
  %{name: "Okitipupa", state: "Ondo"},
  %{name: "Ondo East", state: "Ondo"},
  %{name: "Ondo West", state: "Ondo"},
  %{name: "Ose", state: "Ondo"},
  %{name: "Owo", state: "Ondo"},
  %{name: "Aiyedade", state: "Osun"},
  %{name: "Aiyedire", state: "Osun"},
  %{name: "Atakumosa East", state: "Osun"},
  %{name: "Atakumosa West", state: "Osun"},
  %{name: "Boluwaduro", state: "Osun"},
  %{name: "Boripe", state: "Osun"},
  %{name: "Ede North", state: "Osun"},
  %{name: "Ede South", state: "Osun"},
  %{name: "Egbedore", state: "Osun"},
  %{name: "Ejigbo", state: "Osun"},
  %{name: "Ife Central", state: "Osun"},
  %{name: "Ife East", state: "Osun"},
  %{name: "Ife North", state: "Osun"},
  %{name: "Ife South", state: "Osun"},
  %{name: "Ifedayo", state: "Osun"},
  %{name: "Ifelodun", state: "Osun"},
  %{name: "Ila", state: "Osun"},
  %{name: "Ilesha East", state: "Osun"},
  %{name: "Ilesha West", state: "Osun"},
  %{name: "Irepodun", state: "Osun"},
  %{name: "Irewole", state: "Osun"},
  %{name: "Isokan", state: "Osun"},
  %{name: "Iwo", state: "Osun"},
  %{name: "Obokun", state: "Osun"},
  %{name: "Odo-Otin", state: "Osun"},
  %{name: "Ola-Oluwa", state: "Osun"},
  %{name: "Olorunda", state: "Osun"},
  %{name: "Oriade", state: "Osun"},
  %{name: "Orolu", state: "Osun"},
  %{name: "Osogbo", state: "Osun"},
  %{name: "Afijio", state: "Oyo"},
  %{name: "Akinyele", state: "Oyo"},
  %{name: "Atiba", state: "Oyo"},
  %{name: "Atigbo", state: "Oyo"},
  %{name: "Egbeda", state: "Oyo"},
  %{name: "IbadanCentral", state: "Oyo"},
  %{name: "Ibadan North", state: "Oyo"},
  %{name: "Ibadan North West", state: "Oyo"},
  %{name: "Ibadan South East", state: "Oyo"},
  %{name: "Ibadan South West", state: "Oyo"},
  %{name: "Ibarapa Central", state: "Oyo"},
  %{name: "Ibarapa East", state: "Oyo"},
  %{name: "Ibarapa North", state: "Oyo"},
  %{name: "Ido", state: "Oyo"},
  %{name: "Irepo", state: "Oyo"},
  %{name: "Iseyin", state: "Oyo"},
  %{name: "Itesiwaju", state: "Oyo"},
  %{name: "Iwajowa", state: "Oyo"},
  %{name: "Kajola", state: "Oyo"},
  %{name: "Lagelu Ogbomosho North", state: "Oyo"},
  %{name: "Ogbmosho South", state: "Oyo"},
  %{name: "Ogo Oluwa", state: "Oyo"},
  %{name: "Olorunsogo", state: "Oyo"},
  %{name: "Oluyole", state: "Oyo"},
  %{name: "Ona-Ara", state: "Oyo"},
  %{name: "Orelope", state: "Oyo"},
  %{name: "Ori Ire", state: "Oyo"},
  %{name: "Oyo East", state: "Oyo"},
  %{name: "Oyo West", state: "Oyo"},
  %{name: "Saki East", state: "Oyo"},
  %{name: "Saki West", state: "Oyo"},
  %{name: "Surulere", state: "Oyo"},
  %{name: "Barikin Ladi", state: "Plateau"},
  %{name: "Bassa", state: "Plateau"},
  %{name: "Bokkos", state: "Plateau"},
  %{name: "Jos East", state: "Plateau"},
  %{name: "Jos North", state: "Plateau"},
  %{name: "Jos South", state: "Plateau"},
  %{name: "Kanam", state: "Plateau"},
  %{name: "Kanke", state: "Plateau"},
  %{name: "Langtang North", state: "Plateau"},
  %{name: "Langtang South", state: "Plateau"},
  %{name: "Mangu", state: "Plateau"},
  %{name: "Mikang", state: "Plateau"},
  %{name: "Pankshin", state: "Plateau"},
  %{name: "Qua'an Pan", state: "Plateau"},
  %{name: "Riyom", state: "Plateau"},
  %{name: "Shendam", state: "Plateau"},
  %{name: "Wase", state: "Plateau"},
  %{name: "Abua/Odual", state: "Rivers"},
  %{name: "Ahoada East", state: "Rivers"},
  %{name: "Ahoada West", state: "Rivers"},
  %{name: "Akuku Toru", state: "Rivers"},
  %{name: "Andoni", state: "Rivers"},
  %{name: "Asari-Toru", state: "Rivers"},
  %{name: "Bonny", state: "Rivers"},
  %{name: "Degema", state: "Rivers"},
  %{name: "Emohua", state: "Rivers"},
  %{name: "Eleme", state: "Rivers"},
  %{name: "Etche", state: "Rivers"},
  %{name: "Gokana", state: "Rivers"},
  %{name: "Ikwerre", state: "Rivers"},
  %{name: "Khana", state: "Rivers"},
  %{name: "Obia/Akpor", state: "Rivers"},
  %{name: "Ogba/Egbema/Ndoni", state: "Rivers"},
  %{name: "Ogu/Bolo", state: "Rivers"},
  %{name: "Okrika", state: "Rivers"},
  %{name: "Omumma", state: "Rivers"},
  %{name: "Opobo/Nkoro", state: "Rivers"},
  %{name: "Oyigbo", state: "Rivers"},
  %{name: "Port-Harcourt", state: "Rivers"},
  %{name: "Tai", state: "Rivers"},
  %{name: "Binji", state: "Sokoto"},
  %{name: "Bodinga", state: "Sokoto"},
  %{name: "Dange-shnsi", state: "Sokoto"},
  %{name: "Gada", state: "Sokoto"},
  %{name: "Goronyo", state: "Sokoto"},
  %{name: "Gudu", state: "Sokoto"},
  %{name: "Gawabawa", state: "Sokoto"},
  %{name: "Illela", state: "Sokoto"},
  %{name: "Isa", state: "Sokoto"},
  %{name: "Kware", state: "Sokoto"},
  %{name: "kebbe", state: "Sokoto"},
  %{name: "Rabah", state: "Sokoto"},
  %{name: "Sabon birni", state: "Sokoto"},
  %{name: "Shagari", state: "Sokoto"},
  %{name: "Silame", state: "Sokoto"},
  %{name: "Sokoto North", state: "Sokoto"},
  %{name: "Sokoto South", state: "Sokoto"},
  %{name: "Tambuwal", state: "Sokoto"},
  %{name: "Tqngaza", state: "Sokoto"},
  %{name: "Tureta", state: "Sokoto"},
  %{name: "Wamako", state: "Sokoto"},
  %{name: "Wurno", state: "Sokoto"},
  %{name: "Yabo", state: "Sokoto"},
  %{name: "Ardo-kola", state: "Taraba"},
  %{name: "Bali", state: "Taraba"},
  %{name: "Donga", state: "Taraba"},
  %{name: "Gashaka", state: "Taraba"},
  %{name: "Cassol", state: "Taraba"},
  %{name: "Ibi", state: "Taraba"},
  %{name: "Jalingo", state: "Taraba"},
  %{name: "Karin-Lamido", state: "Taraba"},
  %{name: "Kurmi", state: "Taraba"},
  %{name: "Lau", state: "Taraba"},
  %{name: "Sardauna", state: "Taraba"},
  %{name: "Takum", state: "Taraba"},
  %{name: "Ussa", state: "Taraba"},
  %{name: "Wukari", state: "Taraba"},
  %{name: "Yorro", state: "Taraba"},
  %{name: "Zing", state: "Taraba"},
  %{name: "Bade", state: "Yobe"},
  %{name: "Bursari", state: "Yobe"},
  %{name: "Damaturu", state: "Yobe"},
  %{name: "Fika", state: "Yobe"},
  %{name: "Fune", state: "Yobe"},
  %{name: "Geidam", state: "Yobe"},
  %{name: "Gujba", state: "Yobe"},
  %{name: "Gulani", state: "Yobe"},
  %{name: "Jakusko", state: "Yobe"},
  %{name: "Karasuwa", state: "Yobe"},
  %{name: "Karawa", state: "Yobe"},
  %{name: "Machina", state: "Yobe"},
  %{name: "Nangere", state: "Yobe"},
  %{name: "Nguru Potiskum", state: "Yobe"},
  %{name: "Tarmua", state: "Yobe"},
  %{name: "Yunusari", state: "Yobe"},
  %{name: "Yusufari", state: "Yobe"},
  %{name: "Anka", state: "Zamfara"},
  %{name: "Bakura", state: "Zamfara"},
  %{name: "Birnin Magaji", state: "Zamfara"},
  %{name: "Bukkuyum", state: "Zamfara"},
  %{name: "Bungudu", state: "Zamfara"},
  %{name: "Gummi", state: "Zamfara"},
  %{name: "Gusau", state: "Zamfara"},
  %{name: "Kaura", state: "Zamfara"},
  %{name: "Namoda", state: "Zamfara"},
  %{name: "Maradun", state: "Zamfara"},
  %{name: "Maru", state: "Zamfara"},
  %{name: "Shinkafi", state: "Zamfara"},
  %{name: "Talata Mafara", state: "Zamfara"},
  %{name: "Tsafe", state: "Zamfara"},
  %{name: "Zurmi", state: "Zamfara"}
]

for local_government_area <- local_government_areas do
  state = Repo.get_by(State, name: local_government_area[:state])
  if Repo.get_by(LocalGovernmentArea, [name: local_government_area[:name], state_id: state.id]) == nil do
    local_government_area_params = %{name: local_government_area[:name], state_id: state.id}
    changeset = LocalGovernmentArea.changeset(%LocalGovernmentArea{}, local_government_area_params)
    if changeset.valid?, do: Repo.insert!(changeset)
  end
end


term_set = Repo.get_by(TermSet, [name: "faculty_type"])
faculty_type = Repo.get_by(Term, [description: "Academic", term_set_id: term_set.id])
faculty_type_2 = Repo.get_by(Term, [description: "Non Academic", term_set_id: term_set.id])

faculties = [
  %{name: "School of General Studies", faculty_type_id: faculty_type.id},
  %{name: "School of Art and Design", faculty_type_id: faculty_type.id},
  %{name: "School of Business Studies", faculty_type_id: faculty_type.id},
  %{name: "School of Engineering", faculty_type_id: faculty_type.id},
  %{name: "School of Applied Sciences", faculty_type_id: faculty_type.id},
  %{name: "Rectory", faculty_type_id: faculty_type_2.id},
  %{name: "Registry", faculty_type_id: faculty_type_2.id},
  %{name: "Bursary", faculty_type_id: faculty_type_2.id},
  %{name: "Library", faculty_type_id: faculty_type_2.id},
  %{name: "Service", faculty_type_id: faculty_type_2.id}
]
for faculty <- faculties do
  result = Repo.get_by(Faculty, [name: faculty[:name]])
  if result == nil do
    changeset = Faculty.changeset(%Faculty{}, faculty)
    if changeset.valid? do
      Repo.insert!(changeset)
    end
  end
end


department_list = [
  %{name: "Fashion Design and Clothing Technology", abbreviation: "FAS", school: "School of Art and Design", program: "NDHND"},
  %{name: "Fine and Applied Art", abbreviation: "FAA", school: "School of Art and Design", program: "NDHND"},
  %{name: "Accountancy", abbreviation: "ACC", school: "School of Business Studies", program: "NDHND"},
  %{name: "Business Administration", abbreviation: "BAM", school: "School of Business Studies", program: "NDHND"},
  %{name: "Office Technology and Management", abbreviation: "OTM", school: "School of Business Studies", program: "NDHND"},
  %{name: "Mass Communication", abbreviation: "MCM", school: "School of Business Studies", program: "NDHND"},
  %{name: "Mechanical Engineering", abbreviation: "MEC", school: "School of Engineering", program: "NDHND"},
  %{name: "Welding and Fabrication", abbreviation: "WED", school: "School of Engineering", program: "NDHND"},
  %{name: "Hospitality", abbreviation: "HTM", school: "School of Applied Sciences", program: "NDHND"},
  %{name: "Computer Science", abbreviation: "COM", school: "School of Applied Sciences", program: "NDHND"},
  %{name: "Mathematics and Statistics", abbreviation: "STA", school: "School of Applied Sciences", program: "NDHND"},
  %{name: "Electrical/Electronics Engineering", abbreviation: "EEE", school: "School of Engineering", program: "ND"},
  %{name: "Foundry Engineering", abbreviation: "FDT", school: "School of Engineering", program: "NDHND"},
  %{name: "Computer Engineering", abbreviation: "CET", school: "School of Engineering", program: "ND"},
  %{name: "Metallurgical Engineering", abbreviation: "MET", school: "School of Engineering", program: "NDHND"},
  %{name: "Human Resources Management", abbreviation: "HRM", school: "School of Business Studies", program: "HND"},
  %{name: "Production Operations Management", abbreviation: "POM", school: "School of Business Studies", program: "HND"},
  %{name: "Banking and Finance", abbreviation: "BNF", school: "School of Business Studies", program: "ND"},
  %{name: "Marketing", abbreviation: "MKT", school: "School of Business Studies", program: "ND"},
  %{name: "Agricultural & Bio-Environmental Engineering Technology", abbreviation: "ABE", school: "School of Engineering", program: "ND"},
  %{name: "Civil Engineering Technology", abbreviation: "CEC", school: "School of Engineering", program: "ND"},
]

add_department_to_faculty = fn (departments, faculty)->
  faculty = Repo.get_by(Faculty, name: faculty)
  for department <- departments do
    %Department{}
    |> Department.changeset(department |> Map.put(:faculty_id, faculty.id))
    |> Repo.insert!()
  end
end


for dept <- department_list do
  if Repo.get_by(Department, name: dept[:name]) == nil do
    faculty = Repo.get_by(Faculty, name: dept[:school])
    department = %{name: dept[:name], code: dept[:abbreviation], faculty_id: faculty.id}
    changeset = Department.changeset(%Department{}, department)
    if changeset.valid? do
      department = Repo.insert!(changeset)
      program_length = String.length(dept[:program])
      programs = case program_length do
        5 ->  ["ND", "HND"]
        3 ->  ["HND"]
        2 ->  ["ND"]
      end
      for p <- programs do
        program = Repo.get_by(Program, name: p)
        program_department = %{program_id: program.id, department_id: department.id}
        changeset = ProgramDepartment.changeset(%ProgramDepartment{}, program_department)
        if changeset.valid? do
          Repo.insert!(changeset)
        end
      end
    end
  end
end

[
  %{name: "Rector’s Office"},
  %{name: "Deputy Rector (Academic)"},
  %{name: "Student Affairs"},
  %{name: "Internal Audit"},
  %{name: "Student Industrial Work Experience/Placement )SIWES"},
  %{name: "Public Relations"},
  %{name: "Information and Communication Technology (ICT)"}
]
|> add_department_to_faculty.("Rectory")

[
  %{name: "Registrar’s Main Office"},
  %{name: "Personnel Department"},
  %{name: "Academic Registry Department"},
  %{name: "Admissions Department"}
]
|> add_department_to_faculty.("Registry")

[
  %{name: "Bursar’s Office"},
  %{name: "Students Accounts"},
  %{name: "Final Accounts"},
  %{name: "Budget and Expenditure Control"},
  %{name: "Payroll"},
  %{name: "Central Stores"},
  %{name: "Cash Office"}
]
|> add_department_to_faculty.("Bursary")
[
  %{name: "Circulation"},
  %{name: "Reference"},
  %{name: "Serials"},
  %{name: "Reserve Collection"}
]
|> add_department_to_faculty.("Library")

[
  %{name: "Physical Planning and Development Division"},
  %{name: "Works and Maintenance"},
  %{name: "Medical Centre"}
]
|> add_department_to_faculty.("Service")

core_course = Term |> Ecto.Query.join(:inner, [t], ts in assoc(t, :term_set)) |> Ecto.Query.where([t, ts], t.description == "Core" and ts.name == "course_category") |> Repo.one
gns_course = Term |> Ecto.Query.join(:inner, [t], ts in assoc(t, :term_set)) |> Ecto.Query.where([t, ts], t.description == "GNS" and ts.name == "course_category") |> Repo.one
elective_course = Term |> Ecto.Query.join(:inner, [t], ts in assoc(t, :term_set)) |> Ecto.Query.where([t, ts], t.description == "Elective" and ts.name == "course_category") |> Repo.one


courses = [
  %{code: "BFN 111", title: "ELEMENTS OF BANKING I", units: 2, hours: 60, level: "ND I", program: "ND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "BFN 112", title: "PRINCIPLES OF ECONOMICS I", units: 3, hours: 45, level: "ND I", program: "ND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 111", title: "CITIZENSHIP EDUCATION", units: 2, hours: 30, level: "ND I", program: "ND", department: "Accountancy", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 103", title: "USE OF LIBRARY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Accountancy", semester: "1st", course_category_id: gns_course.id},
  %{code: "OTM 101", title: "TECHNICAL ENGLISH I", units: 4, hours: 60, level: "ND I", program: "ND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 113", title: "INFORMATION COMMUNICATION TECHNOLOGY I", units: 4, hours: 60, level: "ND I", program: "ND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 112", title: "BUSINESS MATHEMATICS I", units: 3, hours: 45, level: "ND I", program: "ND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 113", title: "PRINCIPLES OF LAW", units: 2, hours: 30, level: "ND I", program: "ND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 111", title: "PRINCIPLES OF ACCOUNTS I", units: 4, hours: 60, level: "ND I", program: "ND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 211", title: "PRINCIPLES OF MANAGEMENT I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 121", title: "CITIZENSHIP EDUCATION", units: 2, hours: 30, level: "ND I", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: gns_course.id},
  %{code: "BAM 126", title: "INTRODUCTION TO ENTREPRENEURSHIP", units: 2, hours: 30, level: "ND I", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 122", title: "BUSINESS MATHEMATICS II", units: 3, hours: 45, level: "ND I", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "BFN 121", title: "ELEMENTS OF BANKING II", units: 2, hours: 30, level: "ND I", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "BFN 122", title: "PRINCIPLES OF ECONOMICS II", units: 3, hours: 45, level: "ND I", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 121", title: "PRINCIPLES OF ACCOUNTS II", units: 4, hours: 45, level: "ND I", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 201", title: "TECHNICAL ENGLISH II", units: 4, hours: 60, level: "ND I", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 214", title: "INFORMATION COMMUNICATIONS TECHNOLOGY II", units: 4, hours: 60, level: "ND I", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 221", title: "PRINCIPLES OF MANAGEMENT II", units: 2, hours: 30, level: "ND I", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 214", title: "BUSINESS LAW", units: 2, hours: 30, level: "ND I", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 211", title: "FINANCIAL ACCOUNTING I", units: 4, hours: 60, level: "ND II", program: "ND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 212", title: "COST ACCOUNTING I", units: 4, hours: 60, level: "ND II", program: "ND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 213", title: "AUDITING I", units: 3, hours: 45, level: "ND II", program: "ND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 214", title: "TAXATION I", units: 3, hours: 45, level: "ND II", program: "ND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "BFN 213", title: "BUSINESS RESEARCH METHODS", units: 2, hours: 30, level: "ND II", program: "ND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "EED 216", title: "PRACTICE OF ENTREPRENEURSHIP", units: 2, hours: 30, level: "ND II", program: "ND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 212", title: "BUSINESS STATISTICS", units: 3, hours: 45, level: "ND II", program: "ND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 424", title: "COMPANY LAW", units: 2, hours: 30, level: "ND II", program: "ND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 222", title: "BUSINESS STATISTICS II", units: 3, hours: 45, level: "ND II", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "BFN 211", title: "BUSINESS FINANCE", units: 3, hours: 45, level: "ND II", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 223", title: "AUDITING II", units: 3, hours: 45, level: "ND II", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 222", title: "COST ACCOUNTING II", units: 4, hours: 60, level: "ND II", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 224", title: "TAXATION II", units: 3, hours: 45, level: "ND II", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 221", title: "FINANCIAL ACCOUNTING II", units: 4, hours: 60, level: "ND II", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 225", title: "PUBLIC SECTOR ACCOUNTING", units: 2, hours: 30, level: "ND II", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 229", title: "PROJECT", units: 2, hours: 30, level: "ND II", program: "ND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 311", title: "ACCOUNTING THEORY AND PRACTICE", units: 4, hours: 60, level: "HND I", program: "HND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 312", title: "ADVANCED COSTING I", units: 4, hours: 60, level: "HND I", program: "HND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 313", title: "BANKRUPTCY, EXECUTORSHIP, TRUST  LAW AND ACCOUNTS", units: 2, hours: 30, level: "HND I", program: "HND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 315", title: "QUANTITATIVE TECHNIQUES", units: 3, hours: 45, level: "HND I", program: "HND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 316", title: "PUBLIC FINANCE", units: 3, hours: 45, level: "HND I", program: "HND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 317", title: "MANAGEMENT INFORMATION SYSTEM I", units: 2, hours: 30, level: "HND I", program: "HND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "HBF 427", title: "MANAGERIAL ECONOMICS", units: 4, hours: 60, level: "HND I", program: "HND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 412", title: "BUSINESS COMMUNICATIONS I", units: 4, hours: 60, level: "HND I", program: "HND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 321", title: "ADVANCED FINANCIAL ACCOUNTING I", units: 4, hours: 60, level: "HND I", program: "HND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 322", title: "ADVANCED COSTING II", units: 4, hours: 60, level: "HND I", program: "HND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 324", title: "ADVANCED TAXATION I", units: 3, hours: 45, level: "HND I", program: "HND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 326", title: "PUBLIC SECTOR ACCOUNTING I", units: 4, hours: 60, level: "HND I", program: "HND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 327", title: "MANAGEMENT INFORMATION SYSTEM II", units: 2, hours: 30, level: "HND I", program: "HND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "HBF 413", title: "BUSINESS RESEARCH METHODS", units: 3, hours: 45, level: "HND I", program: "HND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 413", title: "ENTREPRENEURSHIP DEVELOPMENT", units: 2, hours: 30, level: "HND I", program: "HND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 424", title: "PROFESSIONAL ETHICS AND SOCIAL RESPONSIBILITY", units: 4, hours: 60, level: "HND I", program: "HND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 411", title: "ADVANCED FINANCIAL ACCOUNTING II", units: 4, hours: 60, level: "HND I", program: "HND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 412", title: "AUDITING AND INVESTIGATIONS", units: 3, hours: 45, level: "HND I", program: "HND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 413", title: "FINANCIAL MANAGEMENT I", units: 3, hours: 45, level: "HND I", program: "HND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 414", title: "ADVANCED TAXATION II", units: 3, hours: 45, level: "HND I", program: "HND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 415", title: "MANAGEMENT ACCOUNTING I", units: 4, hours: 60, level: "HND I", program: "HND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 416", title: "PUBLIC SECTOR ACCOUNTING II", units: 3, hours: 45, level: "HND I", program: "HND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 418", title: "SMALL BUSINESS MANAGEMENT", units: 2, hours: 30, level: "HND I", program: "HND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 422", title: "BUSINESS COMMUNICATIONS II", units: 4, hours: 60, level: "HND I", program: "HND", department: "Accountancy", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 421", title: "ADVANCED FINANCIAL ACCOUNTING III", units: 4, hours: 60, level: "HND I", program: "HND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 422", title: "AUDIT PRACTICE & ASSURANCE SERVICES", units: 3, hours: 45, level: "HND I", program: "HND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 423", title: "FINANCIAL MANAGEMENT II", units: 4, hours: 60, level: "HND I", program: "HND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 424", title: "MULTI-DISCIPLINARY CASE STUDY", units: 2, hours: 30, level: "HND I", program: "HND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 425", title: "MANAGEMENT ACCOUNTING II", units: 4, hours: 60, level: "HND I", program: "HND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 428", title: "PROJECT", units: 3, hours: 45, level: "HND I", program: "HND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 322", title: "PROFESSIONAL CAREER DEVELOPMENT", units: 4, hours: 60, level: "HND I", program: "HND", department: "Accountancy", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 111", title: "PRINCIPLES OF ACCOUNTS I", units: 4, hours: 60, level: "ND I", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS103", title: "USE OF LIBRARY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Business Administration", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 113", title: "CITIZENSHIP EDUCATION", units: 2, hours: 30, level: "ND I", program: "ND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "PUS 111", title: "PRINCIPLE PURCHASING", units: 3, hours: 30, level: "ND I", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "PAD 111", title: "ELEMENT OF PUBLIC ADMIN", units: 3, hours: 30, level: "ND I", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "MKT 111", title: "PINCIPLE OF MARKETING", units: 3, hours: 30, level: "ND I", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 114", title: "PRINCIPLE OF ECONOMICS", units: 3, hours: 30, level: "ND I", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 113", title: "PRINCIPLE OF LAW", units: 3, hours: 30, level: "ND I", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 112", title: "BUSINESS MATHEMATICS", units: 3, hours: 30, level: "ND I", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 111", title: "INTRODUCTION TO BUSINESS", units: 3, hours: 30, level: "ND I", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 121", title: "INTRODUCTION TO BUSINESS II", units: 3, hours: 30, level: "ND I", program: "ND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 102", title: "COMMUNICATION IN ENGLISH I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Business Administration", semester: "2nd", course_category_id: gns_course.id},
  %{code: "BAM 123", title: "INTRODUCTION TO SOCIAL PSYCHOLOGY", units: 3, hours: 30, level: "ND I", program: "ND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 121", title: "PRINCIPLE OF ACCOUNTS II", units: 4, hours: 60, level: "ND I", program: "ND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 125", title: "INTRODUCTION TO TECHNOLOGY I", units: 6, hours: 60, level: "ND I", program: "ND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 126", title: "INTRODUCTION TO ENTERPRENEUSHIP", units: 3, hours: 30, level: "ND I", program: "ND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 124", title: "PRINCIPLES OF ECONOMICS II", units: 3, hours: 30, level: "ND I", program: "ND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 214", title: "GENERAL BIOLOGY", units: 2, hours: 30, level: "ND II", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 218", title: "COST ACCOUNTING", units: 3, hours: 30, level: "ND II", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 217", title: "RESEARCH METHOD", units: 3, hours: 30, level: "ND II", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 214", title: "BUSINESS LAW", units: 3, hours: 30, level: "ND II", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 213", title: "OFFICE MANAGEMENT", units: 3, hours: 30, level: "ND II", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 212", title: "BUSINESS STATISTICS", units: 3, hours: 30, level: "ND II", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 211", title: "PRINCIPLE OF MANAGEMENT", units: 3, hours: 30, level: "ND II", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 215", title: "INTRODUCTION TO INFORMATION TECHNOLOGY", units: 6, hours: 60, level: "ND II", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 216", title: "PRACTICES OF ENTERPRENEUSHIP", units: 3, hours: 30, level: "ND II", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 202", title: "COMMUNICATION IN ENGLISH", units: 2, hours: 30, level: "ND II", program: "ND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 222", title: "BUSINESS STATISTICS II", units: 3, hours: 30, level: "ND II", program: "ND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 223", title: "ELEMENT OF PRODUCTION MANAGEMENT", units: 3, hours: 30, level: "ND II", program: "ND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 225", title: "PROJECT", units: 5, hours: 60, level: "ND II", program: "ND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 212", title: "COST ACCOUNTING II", units: 4, hours: 60, level: "ND II", program: "ND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 220", title: "PHYSICS/CHEMISTRY", units: 2, hours: 30, level: "ND II", program: "ND", department: "Business Administration", semester: "2nd", course_category_id: gns_course.id},
  %{code: "BAM 224", title: "ELEMENTS OF HUMAN CAPITAL MANAGEMENT", units: 3, hours: 30, level: "ND II", program: "ND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 221", title: "PRINCIPLE OF MANAGEMENT", units: 3, hours: 30, level: "ND II", program: "ND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 202", title: "COMMUNICATION IN ENGLISH II", units: 2, hours: 30, level: "ND II", program: "ND", department: "Business Administration", semester: "2nd", course_category_id: gns_course.id},
  %{code: "ARD 101", title: "BASIC DESIGN", units: 3, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 103", title: "LIFE DRAWING", units: 2, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 105", title: "INTO-SCULTURE", units: 3, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 107", title: "INTRO-CERAMICS", units: 3, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 109", title: "INTRO-GRAPHICS", units: 3, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 111", title: "INTRO-TEXTILES", units: 3, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD113", title: "INTRO-PAINTAING", units: 3, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 115", title: "ART HISTORY", units: 2, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 119", title: "GENERAL DRAWINGS", units: 1, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 101", title: "USE OF ENGLISH", units: 1, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 103", title: "USE OF LIBRARY", units: 1, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 111", title: "CITIZENSHIP EDUCATION I", units: 1, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: gns_course.id},
  %{code: "CMP 101", title: "INTRO-COMPUTER", units: 1, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "PTG 111", title: "INTRO-PRINTING", units: 3, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 101", title: "TECHNICAL DRAWING", units: 1, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 114", title: "PAINTING", units: 3, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 104", title: "LIFE DRAWING", units: 2, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 106", title: "SCULTURE", units: 3, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 108", title: "CERAMICS", units: 3, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 110", title: "GRAPHICS", units: 3, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 112", title: "TEXTILE", units: 3, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 102", title: "BASIC DESIGN II", units: 3, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "PTG 112", title: "PRINTING", units: 1, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 102", title: "COMMUNICATION IN ENGLISH I", units: 1, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: gns_course.id},
  %{code: "MEC 102", title: "TECHNICAL DRAWING", units: 1, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "CMP 102", title: "FURTHER INFORMATION TO TECHNOLOGY", units: 1, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "EED 126", title: "ENTREPRENEURSHIP STUDIES", units: 1, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 116", title: "ART HISTORY", units: 2, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 120", title: "GENERAL DRAWING", units: 1, hours: 45, level: "ND I", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 201", title: "BASIC DESIGN", units: 3, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 203", title: "LIFE DRAWING", units: 2, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 205", title: "SCULTURE", units: 3, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 207", title: "CERAMICS", units: 3, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 209", title: "GRAPHICS", units: 3, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 211", title: "TEXTILE DESIGN", units: 3, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 213", title: "PAINTING", units: 3, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 215", title: "ART HISTORY", units: 2, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 219", title: "GENERAL DRAWING", units: 1, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 125", title: "ECONOMICS", units: 1, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 201", title: "USE OF ENGLISH II", units: 1, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: gns_course.id},
  %{code: "PTG 211", title: "PRINTING", units: 3, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 217", title: "SIWES", units: 4, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 201", title: "TECHNICAL DRAWING", units: 1, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "RMD 206", title: "RESEARCH METHODS", units: 1, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "EED 216", title: "ENTREPRENEURSHIP STUDIES", units: 1, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 202", title: "BASIC DESIGN", units: 3, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 204", title: "LIFE DRAWING", units: 2, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 206", title: "SCULTURE", units: 3, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 208", title: "CERAMICS", units: 3, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 210", title: "GRAPHICS", units: 3, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 212", title: "TEXTILE", units: 3, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 214", title: "PAINTING", units: 3, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 216", title: "ART HISTORY", units: 2, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 220", title: "GENERAL DRAWING", units: 1, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 202", title: "COMMUNICATION IN ENGLISH II", units: 1, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: gns_course.id},
  %{code: "PTG 212", title: "PRINTING", units: 3, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 218", title: "PROJECT", units: 6, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 202", title: "TECHNICAL DRAWING", units: 1, hours: 45, level: "ND II", program: "ND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "SCU 306", title: "CARVING [SCULTURE]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 301", title: "LIFE AND GENERAL DRAWING [SCULTURE]", units: 3, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 315", title: "ART HISTORY [SCULTURE]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "SCU 301", title: "MATERIALS AND METHODS [SCULTURE]", units: 3, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "SCU 303", title: "LIFE STUDY AND MODELLING [SCULTURE]", units: 3, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "SCU 310", title: "CONSTRUCTION [SCULTURE]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "SCU 307", title: "CARVING [SCULTURE]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 302", title: "LIFE AND GENERAL DRAWING [SCULTURE]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 316", title: "ART HISTORY [SCULTURE]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "SCU 302", title: "MATERIAL AND METHOD [SCULTURE]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "SCU 304", title: "LIFE STUDY MODELLING [SCULTURE]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "SCU 311", title: "CONSTRUCTION [SCULTURE]", units: 3, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "SCU 313", title: "COMPOSITION [SCULTURE]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 302", title: "USE OF ENGLISH [SCULTURE]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: gns_course.id},
  %{code: "SCU 308", title: "MODELLING AND CASTING [SCULTURE]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 312", title: "MORAL PHILOSOPHY [SCULTURE]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: gns_course.id},
  %{code: "RMD 302", title: "RESEARCH METHOD [SCULTURE]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 301", title: "LIFE AND GENERAL DRAWING [PAINTING]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 315", title: "ART HISTORY [PAINTING]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "PAT 303", title: "LIFE PAINTING [PAINTING]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "PAT 311", title: "PICTORIAL COMPOSITION [PAINTING]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "PAT 309", title: "MIXED MEDIA [PAINTING]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "PAT 307", title: "OUTDOOR PAINTING [PAINTING]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 301", title: "USE OF ENGLISH [PAINTING]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: gns_course.id},
  %{code: "EED 413", title: "ENTREPRENEURSHIP [PAINTING]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 302", title: "LIFE AND GENERAL DRAWING [PAINTING]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 316", title: "ART HISTORY [PAINTING]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "PAT 304", title: "LIFE PAINTING [PAINTING]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "PAT 312", title: "PICTORIAL COMPOSITION [PAINTING]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "PAT 310", title: "MIXED MEDIA [PAINTING]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "PAT 308", title: "OUTDOOR PAINTING [PAINTING]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 302", title: "USE OF ENGLISH [PAINTING]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: gns_course.id},
  %{code: "GNS 312", title: "MORAL PHILOSOPHY [PAINTING]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: gns_course.id},
  %{code: "RMD 302", title: "RESEARCH METHOD [PAINTING]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 301", title: "LIFE AND GENERAL DRAWING [GRAPHICS]", units: 3, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 301", title: "USE OF ENGLISH  [GRAPHICS]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: gns_course.id},
  %{code: "ARD 315", title: "ART HISTORY  [GRAPHICS]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "GRH 314", title: "REPROGRAPHIC METHODS [GRAPHICS]", units: 3, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "GRH 316", title: "ADVERTISING  [GRAPHICS]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "GRH 319", title: "PHOTOGRAPH  [GRAPHICS]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "CGR 311", title: "COMPUTER GRAPHICS  [GRAPHICS]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "EED 413", title: "ENTREPRENEURSHIP  [GRAPHICS]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 302", title: "LIFE AND GENERAL DRAWING [GRAPHICS]", units: 3, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 302", title: "USE OF ENGLISH  [GRAPHICS]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: gns_course.id},
  %{code: "ARD 316", title: "ART HISTORY  [GRAPHICS]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "GRH 315", title: "REPROGRAPHIC METHODS [GRAPHICS]", units: 3, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "GRH 317", title: "ADVERTISING  [GRAPHICS]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "GRH 320", title: "PHOTOGRAPH  [GRAPHICS]", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "GRH 318", title: "GRAPHIC ILLUSTRATION", units: 4, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "CGR 312", title: "COMPUTER GRAPHICS  [GRAPHICS]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 312", title: "MORAL PHILOSOPHY [GRAPHICS]", units: 2, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: gns_course.id},
  %{code: "RMD 302", title: "RESEARCH METHOD [GRAPHICS]", units: 1, hours: 45, level: "HND I", program: "HND", department: "Fine and Applied Art", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 111", title: "INTRODUCTION TO HOSPITALITY", units: 3, hours: 45, level: "ND I", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 113", title: "FOOD AND BEVERAGE PRODUCTION", units: 4, hours: 60, level: "ND I", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 114", title: "FOOD BEVERAGE SERVICE I", units: 4, hours: 60, level: "ND I", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 115", title: "HOUSE KEEPING OPERATION", units: 4, hours: 60, level: "ND I", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 112", title: "PHYSICAL & HEALTH EDUCATION", units: 2, hours: 30, level: "ND I", program: "ND", department: "Hospitality", semester: "1st", course_category_id: gns_course.id},
  %{code: "STB 112", title: "MORPHOLOGY AND PHYSIOLOGY OF LIVING THINGS", units: 2, hours: 30, level: "ND I", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "LTM 116", title: "COMPUTER APPLICATION PACKAGE", units: 2, hours: 30, level: "ND I", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 111", title: "INTRODUCTION TO STATISTICS", units: 2, hours: 30, level: "ND I", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 112", title: "FRENCH LANGUAGE I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "LTN 111", title: "INTRODUCTION TO LEISURE RECREATION AND TOURISM", units: 3, hours: 45, level: "ND I", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 122", title: "FOOD & BEVERAGE PRODUCTION II", units: 4, hours: 60, level: "ND I", program: "ND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 123", title: "FOOD & BEVERAGE SERVICE II", units: 4, hours: 60, level: "ND I", program: "ND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 121", title: "FRENCH LANGUAGE II", units: 2, hours: 30, level: "ND I", program: "ND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 124", title: "FRONT OFFICE OPERATION", units: 4, hours: 60, level: "ND I", program: "ND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 125", title: "FOOD HYGIENE & NUTRITION", units: 3, hours: 45, level: "ND I", program: "ND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 127", title: "PRINCIPLES OF ACCOUNTS I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "LMT 124", title: "COMPUTER APPLICATION PACKAGE II", units: 2, hours: 30, level: "ND I", program: "ND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "STC 111", title: "GENERAL PRINCIPLE OF CHEMISTRY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 231", title: "FOOD & BEVERAGE PRODUCTION III", units: 4, hours: 60, level: "ND II", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 232", title: "FOOD & BEVERAGE SERVICES III", units: 4, hours: 60, level: "ND II", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 233", title: "ACCOMMODATION OPERATION I", units: 4, hours: 60, level: "ND II", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 234", title: "FOOD SCIENCE & NUTRITION", units: 3, hours: 45, level: "ND II", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 235", title: "FOOD COSTING & CONTROL", units: 2, hours: 30, level: "ND II", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 236", title: "HOSPITALITY MANAGEMENT", units: 2, hours: 30, level: "ND II", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HNT 237", title: "SIWES", units: 4, hours: 60, level: "ND II", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 121", title: "HOTEL ACCOUNTING", units: 2, hours: 30, level: "ND II", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 228", title: "RESEARCH METHODS", units: 2, hours: 30, level: "ND II", program: "ND", department: "Hospitality", semester: "1st", course_category_id: gns_course.id},
  %{code: "HMT 241", title: "FOOD & BEVERAGE PRODUCTION IV", units: 5, hours: 75, level: "ND II", program: "ND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 242", title: "FOOD & BEVERAGE SERVICE IV", units: 4, hours: 60, level: "ND II", program: "ND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 243", title: "ACCOMMODATION OPERATION II", units: 3, hours: 45, level: "ND II", program: "ND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 244", title: "BAR OPERATION & LIQUOR STUDIES", units: 3, hours: 45, level: "ND II", program: "ND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "LMT 226", title: "SMALL BUSINESS MANAGEMENT", units: 2, hours: 30, level: "ND II", program: "ND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 246", title: "PROJECT", units: 6, hours: 90, level: "ND II", program: "ND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 238", title: "CUSTOMER SERVICE MANAGEMENT", units: 2, hours: 30, level: "ND II", program: "ND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 247", title: "SEMINAR", units: 2, hours: 30, level: "ND II", program: "ND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 211", title: "BUSINESS STATISTICS", units: 2, hours: 30, level: "ND II", program: "ND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 311", title: "FOOD & BEVERAGE PRODUCTION MGT", units: 6, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 312", title: "FOOD & BEVERAGE SERVICE MGT.", units: 6, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 313", title: "ACCOMODATION OPERATION MANAGEMENT", units: 4, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 318", title: "APPLIED NUTRITION", units: 2, hours: 30, level: "HND I", program: "HND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 315", title: "FINANCIAL & ACCOUNTING", units: 3, hours: 45, level: "HND I", program: "HND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 316", title: "TECHNICAL FRENCH I", units: 2, hours: 30, level: "HND I", program: "HND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 317", title: "COMPUTER APPLICATIONS", units: 2, hours: 30, level: "HND I", program: "HND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "OMT 315", title: "BUSINESS COMMUNICATIONS I", units: 2, hours: 30, level: "HND I", program: "HND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 314", title: "HUMAN CAPITAL MGT.", units: 3, hours: 45, level: "HND I", program: "HND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "EED 413", title: "ENTREPRENEURSHIP", units: 2, hours: 30, level: "HND I", program: "HND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 321", title: "FOOD & BEVERAGE PRODUCTION MGT. II", units: 6, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 322", title: "FOOD & BEVERAGE SERVICE MGT. II", units: 6, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 323", title: "PROPERTY MANAGEMENT", units: 4, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 324", title: "HOTEL COSTING & CONTROL", units: 3, hours: 45, level: "HND I", program: "HND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 325", title: "HOTEL & CATERING LAW", units: 2, hours: 30, level: "HND I", program: "HND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 326", title: "TECHNICAL FRENCH II", units: 2, hours: 30, level: "HND I", program: "HND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 431", title: "FOOD & BEVERAGE PRODUCTION MGT.", units: 6, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 432", title: "FOOD & BEVERAGE SERVICE MGT.", units: 6, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 433", title: "FACILITY DESIGN AND MANAGEMENT", units: 6, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 436", title: "CUSTOMER SERVICE MANAGEMENT", units: 4, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 434", title: "HOSPITALITY MARKETING", units: 4, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 435", title: "FINANCIAL MANAGEMENT II", units: 4, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 412", title: "BUSINESS COMMUNICATION II", units: 4, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "HMT 441", title: "FOOD & BEVERAGE PRODUCTION MGT.", units: 6, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 442", title: "FOOD BEVERAGE SERVICE MGT.", units: 6, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 443", title: "FACILITY DESIGN AND MANAGEMENT II", units: 6, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 444", title: "PROJECT", units: 6, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "HMT 445", title: "SMALL BUSINESS MANAGEMENT", units: 4, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 415", title: "ADVANCED DESKTOP PUBLISHING", units: 4, hours: 60, level: "HND I", program: "HND", department: "Hospitality", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 101", title: "USE OF ENGLISH I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 103", title: "USE OF LIBRARY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 111", title: "CITIZENSHIP EDUCATION I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: gns_course.id},
  %{code: "MAC 111", title: "ENGLISH FOR MASS COMMUNICATION I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 112", title: "BASIC FRENCH I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 113", title: "INTRODUCTION TO COMPUTER I", units: 3, hours: 45, level: "ND I", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 114", title: "INTRODUCTION TO MASS COMMUNICATION", units: 3, hours: 45, level: "ND I", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 115", title: "INTRODUCTION TO NEWS GATHERING AND REPORTING", units: 4, hours: 60, level: "ND I", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 116", title: "HISTORY OF NIGERIA PRESS", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 117", title: "HISTORY OF POLITICS IN NIGERIA", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 102", title: "USE OF ENGLISH II", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: gns_course.id},
  %{code: "GNS 121", title: "CITIZENSHIP EDUCATION II", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: gns_course.id},
  %{code: "EED 126", title: "INTRODUCTION TO ENTERPRENEURSHIP", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 121", title: "ENGLISH FOR MASS COMMUNICATION II", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 122", title: "BASIC FRENCH II", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 123", title: "COMPUTER APPLICATION", units: 3, hours: 30, level: "ND I", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 124", title: "GRAPHICS ART AND DESIGN", units: 3, hours: 30, level: "ND I", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 125", title: "INTERMEDIATE NEWS GATHERING/WRITING", units: 3, hours: 30, level: "ND I", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 126", title: "PRINCIPLES OF PUBLIC RELATIONS", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 127", title: "INTRODUCTION TO BROADCASTING", units: 3, hours: 30, level: "ND I", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 201", title: "COMMUNICATION IN ENGLISH III", units: 2, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 211", title: "INTRODUCTION TO SOCIOLOGY", units: 2, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: gns_course.id},
  %{code: "EED 216", title: "PRACTICE OF ENTERPRENEURSHIP", units: 3, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 211", title: "ENGLISH FOR MASS COMMUNICATION III", units: 2, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 212", title: "INTRODUCTION TO RESEARCH METHODS", units: 2, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 213", title: "COPY EDITING", units: 3, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 214", title: "FEATURE WRITING", units: 3, hours: 60, level: "ND II", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 215", title: "MASS MEDIA AND SOCIETY", units: 2, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 216", title: "PRINCIPLES OF ADVERTISING", units: 2, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 217", title: "BROADCAST PRODUCTION I", units: 3, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 218", title: "SIWES", units: 4, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 202", title: "COMMUNICATIONS IN ENGLISH IV", units: 2, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: gns_course.id},
  %{code: "GNS 222", title: "ECONOMICS", units: 2, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: gns_course.id},
  %{code: "GNS 225", title: "GEOPGRAPHY OF NIGERIA", units: 2, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: gns_course.id},
  %{code: "MAC 222", title: "ENGLISH FOR MASS COMMUNICATION IV", units: 2, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 223", title: "NEWSPAPER AND MAGAZINE PRODUCTION", units: 3, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 224", title: "PHOTOGRAPHY AND PHOTO-JOURNALISM", units: 3, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 225", title: "BROADCAST PRODUCTION II", units: 3, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 226", title: "MASS COMMUNICATION LAWS AND ETHICS", units: 2, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 227", title: "INVESTIGATIVE AND INTERPRETATIVE REPORTING", units: 3, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 228", title: "INDIVIDUAL PROJECT", units: 2, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MKT 111", title: "FUNDAMENTAL OF MARKETING FOR PUBLIC RELATIONS AND ADVERTISING", units: 2, hours: 30, level: "ND II", program: "ND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 301", title: "USE OF ENGLISH", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 320", title: "OUTLINE HISTORY OF AFRICA", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: gns_course.id},
  %{code: "CMP 311", title: "COMPUTER APPLICATION", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 311", title: "DESCRIPTIVE STATISTICS", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 312", title: "COMMUNICATION THEORIES", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 313", title: "PUBLIC OPINION RESEARCH", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 314", title: "ADVERTISING COPY WRITING AND LAYOUT PRINCIPLES", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 315", title: "PUBLIC RELATIONS COPY AND MEDIA", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 316", title: "RADIO/TELEVISION PRODUCTION/PRESENTATION", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 317", title: "INTERMEDIATE FILM PRODUCTION", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 321", title: "INTERNATIONAL RELATIONS", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: gns_course.id},
  %{code: "GNS 322", title: "SOCIAL PHILOSOPHY", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: gns_course.id},
  %{code: "GNS 323", title: "PSYCHOLOGY", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: gns_course.id},
  %{code: "EED 323", title: "ELEMENTS OF ENTERPRENEURSHIP", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 321", title: "PRECISION JOURNALISM", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 322", title: "SOCIALOGY OF MASS COMMUNICATION", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 323", title: "MASS COMMUNICATION RESEARCH", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 324", title: "INTERNATIONAL COMMUNICATION AND THE WORLD PRESS", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 325", title: "INTERPERSONAL COMMUNICATION", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 326", title: "CRITICAL WRITING I", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 327", title: "ADVERTISING CAMPAIGN, PLANNING AND EXECUTION", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 401", title: "USE OF ENGLISH [PRINT]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: gns_course.id},
  %{code: "EED 413", title: "ENTERPRENEURSHIP DEVELOPMENT [PRINT]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 410", title: "SOCIAL SCIENCE RESEARCH METHODS [PRINT]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 411", title: "INTRODUCTION TO SCIENCE WRITING[PRINT]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 412", title: "EDITORIAL WRITING[PRINT]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 413", title: "MEDIA ORGANISATION AND MANAGEMENT[PRINT]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 414", title: "ADVANCED REPORTING[PRINT]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 415", title: "NEWSPAPER PRODUCTION[PRINT]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 416", title: "COMMUNITY JOURNALISM AND BROADCASTING [PRINT]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 417", title: "SEMINAR IN MASS COMMUNICATION [PRINT]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 218", title: "INTRODUCTION TO BOOK PUBLISHING [PRINT]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 401", title: "USE OF ENGLISH [BROADCAST]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: gns_course.id},
  %{code: "EED 413", title: "ENTERPRENEURSHIP DEVELOPMENT [BROADCAST]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 410", title: "SOCIAL SCIENCE RESEARCH METHODS [BROADCAST]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 411", title: "INTRODUCTION TO SCIENCE WRITING [BROADCAST]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 412", title: "EDITORIAL WRITING [BROADCAST]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 413", title: "MEDIA ORGANISATION AND MANAGEMENT [BROADCAST]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 416", title: "COMMUNITY JOURNALISM AND BROADCASTING [BROADCAST]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 417", title: "SEMINAR IN MASS COMMUNICATION [BROADCAST]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 418", title: "BROADCAST NEWS PRODUCTION [BROADCAST]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 419", title: "RADIO/TELEVISION PRODUCTION TECHNIQUES [BROADCAST]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "1st", course_category_id: core_course.id},
  %{code: "MAC 403", title: "PROJECT [PRINT]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 421", title: "CRITICAL WRITING II [PRINT]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 422", title: "COMMUNICATION AND NATIONAL DEVELOPMENT [PRINT]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 423", title: "PUBLIC RELATIONS CASE STUDIES [PRINT]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 424", title: "MAGAZINE PRODUCTION [PRINT]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 425", title: "ADVANCED EDITING [PRINT]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 426", title: "ADVANCED PHOTO JORNALISM [PRINT]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 463", title: "COMMUNICATION IN HUMAN ORGANISATIONS [PRINT]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 464", title: "ADVANCED BOOK PUBLISHING [PRINT]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 403", title: "PROJECT [BROADCAST]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 421", title: "CRITICAL WRITING II [BROADCAST]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 422", title: "COMMUNICATION AND NATIONAL DEVELOPMENT [BROADCAST]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 423", title: "PUBLIC RELATIONS CASE STUDIES [BROADCAST]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 427", title: "ADVANCED BROADCAST NEWS PRODUCTION [BROADCAST]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 428", title: "ADVANCED RADIO/TELEVISION PRODUCTION [BROADCAST]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 429", title: "ADVANCED FILM PRODUCTION [BROADCAST]", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MAC 463", title: "COMMUNICATION IN HUMAN ORGANISATIONS [BROADCAST]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mass Communication", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 111", title: "DESCRIPTIVE STATISTICS I", units: 3, hours: 30, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 112", title: "ELEMENTARY PROBABILITY THEORY", units: 4, hours: 45, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "MTH 111", title: "LOGIC AND LINEAR ALGEBRA", units: 3, hours: 30, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "MTH 112", title: "FUNCTION AND GEOMETRY", units: 3, hours: 30, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 101", title: "INTRODUCTION TO COMPUTING", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 113", title: "TECHNICAL ENGLISH I", units: 2, hours: 45, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 111", title: "CITIZENSHIP EDUCATION I", units: 2, hours: 60, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 101", title: "USE OF ENGLISH I", units: 2, hours: 45, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 103", title: "USE OF LIBRARY", units: 2, hours: 45, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: gns_course.id},
  %{code: "COM 113", title: "INTRODUCTION TO PROGRAMMING", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 121", title: "DESCRIPTIVE STATISTICS II", units: 3, hours: 45, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 122", title: "STATISTICAL THEORY I", units: 4, hours: 45, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 123", title: "DEMOGRAPHY I", units: 3, hours: 45, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "MTH 121", title: "CALCULUS I", units: 3, hours: 45, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 101", title: "COMMUNICATION SKILLS I", units: 2, hours: 45, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: gns_course.id},
  %{code: "EED 126", title: "ENTREPRENEURSHIP DEVELOPMENT I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 123", title: "COMPUTER PACKAGES I", units: 2, hours: 60, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 121", title: "CITIZENSHIP EDUCATION II", units: 2, hours: 45, level: "ND I", program: "ND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: gns_course.id},
  %{code: "STA 211", title: "STATISTICS THEORY II", units: 3, hours: 45, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 212", title: "ELEMENTS OF SAMPLE SURVEY", units: 3, hours: 45, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 213", title: "SOCIAL AND ECONOMIC STATISTICS", units: 3, hours: 45, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 214", title: "INDUSTRIAL STATISTICS I", units: 3, hours: 30, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "MTH 212", title: "CALCULUS I", units: 3, hours: 60, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "MTH 213", title: "LINEAR ALGEBRA", units: 3, hours: 30, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 215", title: "COMPUTER PACKAGES II", units: 2, hours: 45, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 201", title: "USE OF ENGLISH II", units: 2, hours: 45, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: gns_course.id},
  %{code: "SIW 201", title: "STUDENT INDUSTRIAL SCHEME WORK EXPERIENCE", units: 4, hours: 45, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "EED 216", title: "ENTREPRENEURSHIP DEVELOPMENT II", units: 2, hours: 45, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 221", title: "DESIGN AND ANALYSIS OF EXPERIMENT I", units: 3, hours: 30, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 222", title: "SAMPLING TECHNIQUES I", units: 3, hours: 45, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 223", title: "APPLIED GENERAL STATISTICS", units: 3, hours: 45, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 224", title: "BIOSTATISTICS", units: 3, hours: 30, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 225", title: "SMALL BUSINESS MANAGEMENT I", units: 2, hours: 45, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 226", title: "PROJECT", units: 5, hours: 45, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "MTH 222", title: "MATHEMATICAL METHODS", units: 3, hours: 45, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 224", title: "MIS", units: 2, hours: 45, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 202", title: "COMMUNICATION SKILLS II", units: 2, hours: 45, level: "ND II", program: "ND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: gns_course.id},
  %{code: "STA 311", title: "STATISTICAL THEORY III", units: 3, hours: 45, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 312", title: "APPLIED GENERAL STATISTICS II", units: 3, hours: 45, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 313", title: "STATISTICS INFERENCE AND SCIENTIFIC METHODS", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 314", title: "OPERATIONS RESEARCH II", units: 3, hours: 45, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 315", title: "TECHNICAL ENGLISH II", units: 2, hours: 45, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "MTH 314", title: "MATHEMATICAL METHODS II", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 312", title: "DATABASE DESIGN I", units: 3, hours: 45, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 311", title: "HISTORY OF AFRICA", units: 2, hours: 45, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 301", title: "USE OF ENGLISH III", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: gns_course.id},
  %{code: "STA 321", title: "STATISTICAL THEORY IV", units: 3, hours: 45, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 322", title: "SAMPLING TECHNIQUES II", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 323", title: "DESIGN AND ANALYSIS OF EXPERIMENT II", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 324", title: "STATISTICAL MANAGEMENT & OPERATIONS", units: 3, hours: 45, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 325", title: "BIOMETRICS", units: 3, hours: 45, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "MTH 322", title: "MATHEMATICAL METHODS III", units: 3, hours: 45, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 322", title: "DATABASED DESIGN II", units: 3, hours: 45, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 302", title: "COMMUNICATION SKILLS III", units: 3, hours: 45, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: gns_course.id},
  %{code: "STA 411", title: "OPERATIONS RESEARCH II", units: 3, hours: 45, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 412", title: "SAMPLING TECHNIQUES III", units: 3, hours: 60, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 413", title: "ECONOMETRICS", units: 2, hours: 60, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 414", title: "ECONOMIC AND SOCIAL STATISTICS II", units: 3, hours: 60, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 415", title: "INDUSTRIAL STATISTICS II", units: 3, hours: 60, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 416", title: "MEDICAL STATISTICS", units: 2, hours: 60, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 417", title: "DESIGN AND ANALYSIS OF EXPERIMENT III", units: 3, hours: 60, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 418", title: "SMALL BUSINESS MANAGEMENT II", units: 2, hours: 60, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 401", title: "USE OF ENGLISH IV", units: 2, hours: 60, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: gns_course.id},
  %{code: "EED 413", title: "ENTREPENUERSHIP DEVELOPMENT", units: 2, hours: 60, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 421", title: "OPERATIONS RESEARCH III", units: 3, hours: 60, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 422", title: "DEMOGRAPHY II", units: 3, hours: 60, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 423", title: "NON-PARAMETRIC STATISTICS", units: 3, hours: 60, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 424", title: "STATISTICAL COMPUTING", units: 3, hours: 60, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 425", title: "TIME SERIES ANALYSIS", units: 3, hours: 60, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 426", title: "MULTIVARIATE METHODS AND STOCHASTIC PROCESS", units: 3, hours: 60, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 427", title: "PROJECT", units: 5, hours: 60, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 402", title: "COMMUNICATION SKILLS IV", units: 2, hours: 60, level: "HND I", program: "HND", department: "Mathematics and Statistics", semester: "2nd", course_category_id: gns_course.id},
  %{code: "GNS 101", title: "USE OF ENGLISH I (GRAMMAR)", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 111", title: "CITIZENSHIP EDUCATION", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: gns_course.id},
  %{code: "MTH 112", title: "ALGEBRA AND ELEMENTARY TRIGONOMETRY", units: 3, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 111", title: "MECHANICAL ENGINEERING SCIENCE(STATISTICS)", units: 4, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 112", title: "TECHNICAL DRAWING", units: 5, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 113", title: "BASIC WORKSHOP TECHNOLOGY AND PRACTICE", units: 5, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "EEC 115", title: "ELECTRICAL ENGINEERING SCIENCE", units: 4, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "ICT 101", title: "INTRODUCTION TO COMPUTING", units: 3, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 114", title: "INTRO TO AUTO TECHNOLOGY AND PRACTICE", units: 3, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 102", title: "COMMUNICATIONS IN ENGLISH (ESSAY&COMPREHENSION)", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: gns_course.id},
  %{code: "EED 126", title: "INTRO TO ENTREPRENUERSHIP", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 121", title: "ENGINEERING GRAPHICS", units: 5, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 122", title: "THERMODYNAMICS 1", units: 4, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 123", title: "MACHINE TOOLS TECHNOLOGY AND PRACTICE", units: 6, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 124", title: "MECHANICAL ENGINEERING SCIENCE(DYNAMICS)", units: 4, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 125", title: "SAFETY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MTH 122", title: "CALCULUS", units: 3, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "EEC 125", title: "ELECTRICAL ENGINEERING SCIENCE 11", units: 4, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "ICT 102", title: "FURTHER IT", units: 3, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 217", title: "TECHNICAL REPORT WRITING", units: 2, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 211", title: "ENGINEERING DRAWING 1", units: 5, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 212", title: "ENGINEERING MEASUREMENTS", units: 2, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 213", title: "THERMODYNAMICS 11", units: 4, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 214", title: "FLUIDS MECHANICS", units: 4, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MTH 211", title: "LOGIC AND LINEAR ALGEBRA", units: 3, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 215", title: "FOUNDRY TECHNOLOGY AND FORGING", units: 3, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "ICT 201", title: "INTRODUCTION TO COMPUTER AIDED DESIGN (ICAD)", units: 3, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "SIW 201", title: "SIWES", units: 4, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 221", title: "SUPERVISORY MANAGEMENT", units: 2, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MTH 222", title: "TRIGONOMETRY AND ANALYTICAL GEOMETRY", units: 3, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 222", title: "STRENGTH OF MATERIALS", units: 4, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 224", title: "PROPERTIES OF MATERIALS", units: 4, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "EED 216", title: "ENTREPRENEURSHIP 11", units: 2, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 225", title: "REFRIGERATION AND AIR CONDITIONIG", units: 3, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 226", title: "PLANT SERVICE AND MAINTENANCE", units: 4, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 223", title: "ENGINEERING DRAWING !!", units: 5, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 227", title: "AUTOMOTIVE TECHNOLOGY AND PRACTICE", units: 3, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 200", title: "FINAL YEAR PROJECT", units: 4, hours: 30, level: "ND II", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 302", title: "COMMUNICATION IN ENGLISH", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: gns_course.id},
  %{code: "MTH 311", title: "ADVANCED ALGEBRA", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 311", title: "ENGINEER IN SOCIETY", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "EED 210", title: "ENTREPRENEURSHIP DEVELOPMENT", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 312", title: "ENGINEERING DESIGN", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 313", title: "STRENGTH OF MATERIALS 1", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 314", title: "INSTRUMENTATION AND CONTROL", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 315", title: "MECHANICS OF MACHINES", units: 4, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 316", title: "CAD/CAM", units: 4, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "ICT 101", title: "COMPUTER PROGRAMMING", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 317", title: "TECHNICAL REPORT WRITING 11", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MTH 312", title: "ADVANCED CALCULUS", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 321", title: "BUSINESS MANAGEMENT", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 322", title: "STRENGTH OF MATERIALS 11", units: 4, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 323", title: "FLUIDS MECHANICS", units: 4, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEM 321", title: "METAL FORMING AND HEAT TREATMENT", units: 6, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEM 322", title: "JOINING AND FABRICATION PROCESSES", units: 6, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEM 323", title: "FOUNDRY TECHNOLOGY AND PRCTICE", units: 4, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MTH 313", title: "NUMERICAL METHOD", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEM 416", title: "CNC PROGRAMMING AND ROBOTICS", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEM 411", title: "METROLOGY", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEM 412", title: "TESTING AND FAILURES OF MATERIALS", units: 4, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 412", title: "FLUID POWER MACHINES", units: 4, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEM 413", title: "MACHINE ELEMENT DESIGN", units: 6, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEM 414", title: "OPERATIONS MANAGEMENT", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEM 415", title: "ENGINEERING MATERIALS AND APPLICATIONS", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEP 411", title: "REFRIGERATION AND AIR CONDITIONIG", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 400", title: "PROJECT", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MTH 413", title: "STATISTICAL METHODS IN ENGINEERING", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 427", title: "QUALITY ASSURANCE", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEM 421", title: "MACHINE TOOLS SYSTEMS", units: 3, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEM 422", title: "MACHINE TOOL PROCESSES", units: 4, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEM 423", title: "PRESS AND CUTTING TOOLS DESIGN", units: 4, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEP 426", title: "STEAM POWER ENGINEERING", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEP 425", title: "INDUSTRIAL ENGINEERING", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 411", title: "ENVIRONMENTAL ENGINEERING", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEM 424", title: "MATERIALS HANDLING", units: 2, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEM 425", title: "JIGS, FIXTURES AND TOOL DESIGN", units: 4, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEM 426", title: "MACHINE ASSEMBLY, INSTALLATION AND COMMISSIONING", units: 4, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 400", title: "PROJECT", units: 6, hours: 30, level: "HND I", program: "HND", department: "Mechanical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "ICT 101", title: "INTRODUCTION TO INFORMATION TECHNOLOGY", units: 3, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 101", title: "USE OF ENGLISH I", units: 2, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 111", title: "CITIZENSHIP EDUCATION", units: 2, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: gns_course.id},
  %{code: "MATH 112", title: "ALGEBRA AND ELEMENTARY TRIGONOMETRY", units: 3, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "EEC 112", title: "ELECTRICAL ENGINEERING SCIENCE I", units: 3, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 103", title: "MECHANICAL ENGINEERING SCIENCE I", units: 5, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 112", title: "TECHNICAL DRAWING", units: 4, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "WEC 110", title: "MATERIAL SCIENCE I", units: 3, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "WEC 112", title: "WELDING TECHNOLOGY I", units: 4, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "WEC 111", title: "FABRICATION TECHNOLOGY", units: 4, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 103", title: "USE OF LIBRARY", units: 2, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: gns_course.id},
  %{code: "WEC 123", title: "FABRICATION PROCESS", units: 4, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 102", title: "COMMUNICATION IN ENGLISH I", units: 2, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: gns_course.id},
  %{code: "MTH 122", title: "TRIGONOMETRY AND ANALYTICAL GEOMETRY", units: 3, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "ICT 102", title: "INTRODUCTION TO INFORMATION TECHNOLOGY", units: 2, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 121", title: "ENGINEERING GRAPHICS", units: 5, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 124", title: "MECHANICAL ENGINEERING SCIENCE II", units: 2, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 120", title: "MATERIAL SCIENCE II", units: 4, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 121", title: "WELDING METALLURGY I", units: 5, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC122", title: "METALLURGY", units: 4, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 124", title: "WELDING TECHNOLOGY II", units: 5, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "EED 126", title: "ENTERPRENEURSHIP DEVELOPMENT", units: 2, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "EEC 125", title: "ELECTRICAL ENGINEERING COURSE", units: 3, hours: 35, level: "ND I", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 211", title: "WELDING TECHNOLOGY III", units: 5, hours: 60, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "WEC 212", title: "BASIC THERMODYNAMICS", units: 2, hours: 30, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "WEC 210", title: "WELDING METALLURGY II", units: 2, hours: 30, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 214", title: "FLUID MECHANICS", units: 4, hours: 60, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 212", title: "ENGINEERING MEASUREMENT", units: 2, hours: 30, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 201", title: "ENGINEERING GRAPHICS", units: 5, hours: 60, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "MTH 211", title: "CALCULUS", units: 2, hours: 30, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "SIW 200", title: "SIWES", units: 4, hours: 60, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 217", title: "TECHNICAL REPORTING WRITING", units: 2, hours: 30, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "EED 216", title: "ENTERPRENEURSHIP DEVELOPMENT", units: 2, hours: 30, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "WEC 113", title: "WELDING AND ENVIRONMENTAL SAFETY", units: 2, hours: 30, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "ICT 201", title: "COMPUTER AIDED DESIGN", units: 2, hours: 30, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "WEC 220", title: "WELDING TECHNOLOGY", units: 5, hours: 60, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 222", title: "WELDING AND FABRICATION DESIGN", units: 4, hours: 60, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 224", title: "INTRODUCTION TO PLASTIC WELDING", units: 4, hours: 60, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 222", title: "STRENGTH OF MATERIAL", units: 5, hours: 60, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 223", title: "ASSEMBLY DRAWING", units: 2, hours: 30, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 223", title: "TESTING AND EVALUATION OF WELDING", units: 5, hours: 60, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MTH 202", title: "LOGIC AND LINEAR ALGEBRA", units: 2, hours: 30, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 225", title: "PROJECT", units: 6, hours: 60, level: "ND II", program: "ND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 311", title: "ENGINEER IN SOCIETY", units: 2, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: gns_course.id},
  %{code: "MTH 311", title: "ADVANCE ALGEBRA", units: 2, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "ICT 201", title: "COMPUTER AIDED DESIGN", units: 3, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 312", title: "ENGINEERING DESIGN", units: 3, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 301", title: "STRENGTH OF MATERIAL", units: 5, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "WEC 310", title: "ADVANCE WELDING METALLURGY I", units: 2, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "WEC 311", title: "ADVANCE WELDING TECHNOLOGY I", units: 5, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "WEC 312", title: "ADVANCE WELDING DESIGN", units: 4, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "WEC 313", title: "PIPE WORK TECHNOLOGY", units: 4, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 302", title: "COMMUNICATION IN ENGLISH III", units: 2, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: gns_course.id},
  %{code: "WEC 321", title: "ADVANCED WELDING TECHNOLOGY II", units: 5, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 320", title: "ADVANCED WELDING METALLURGY", units: 5, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 405", title: "APPLIED THERMONDYNAMICS", units: 5, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 323", title: "WELDING INSPECTION AND CONTROL I", units: 4, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 302", title: "STRENGTH OF MATERIALS", units: 4, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 323", title: "FLUID MECHANICS", units: 2, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 322", title: "CORRISION TECHNOLOGY", units: 2, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "MTH 312", title: "ADVANCED CALCULUS", units: 2, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 413", title: "INDUSTRIAL MANAGEMENT", units: 2, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "2nd", course_category_id: gns_course.id},
  %{code: "MTH 321", title: "NUMERICAL METHODS", units: 2, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "EEC 442", title: "ELECTRICAL POWER AND MECHANICS", units: 5, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "MTH 313", title: "STATISTICAL METHODS IN ENGINEERING", units: 2, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "WEC 410", title: "EQUIPMENT MAINTENANCE", units: 3, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "WEC 411", title: "ADVANCE FABRICATION TECHNOLOGY", units: 5, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "WEC 412", title: "ADVANCE WELDING TECHNOLOGY III", units: 5, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "WEC 413", title: "WELD AND INSPECTION CONTROL II", units: 5, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "WEC 426", title: "PROJECT", units: 3, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "EED 413", title: "ENTERPRENEURSHIP DEVELOPMENT", units: 2, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "1st", course_category_id: core_course.id},
  %{code: "MEP 407", title: "PRODUCTION MANAGEMENT", units: 3, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 420", title: "INDUSTRIAL SAFETY AND ENVIRONMENTAL ENGINEERING", units: 2, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 421", title: "PLASTIC WELDING TECHNOLOGY", units: 5, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 422", title: "WELD INSPECTION AND CONTROL III", units: 2, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 423", title: "UNDERWATER WELDING AND CUTTING TECHNOLOGY", units: 3, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 424", title: "MATERIALS AND PROCESS SELECTION", units: 2, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 425", title: "ADVANCE WELDING FABRICATION PROCESS", units: 5, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "WEC 426", title: "PROJECT", units: 3, hours: 60, level: "HND I", program: "HND", department: "Welding and Fabrication", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 121", title: "PROGRAMMING USING OO JAVA", units: 3, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 122", title: "INTRODUCTION TO INTERNET", units: 3, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 123", title: "COMPUTER APPLICATION PACKAGE I", units: 3, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 124", title: "DATA STRUCTURE AND ALGORITHM", units: 3, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 125", title: "INFORMATION AND FILE MANAGEMENT", units: 3, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 126", title: "COMPUTER SYSTEM TROUBLESHOOTING I", units: 3, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 102", title: "USE OF ENGLISH", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "1st", course_category_id: gns_course.id},
  %{code: "EED 126", title: "ENTREPRENURIAL EDUCATION", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 121", title: "CITIZENSHIP EDUCATION I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "1st", course_category_id: gns_course.id},
  %{code: "COM 101", title: "INTRODUCTION TO COMPUTER", units: 3, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 112", title: "INTRODUCTION TO DIGITAL ELECTRONICS", units: 3, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 113", title: "COMPUTER APPLICATION PACKAGES", units: 3, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "MTH 111", title: "LOGIC AND LINEAR ALGEBRA", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "MTH 112", title: "FUNCTION AND GEOMETRY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 111", title: "DESCRIPTIVE STATISTIC", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 112", title: "ELEMENTARY PROPABILITY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 111", title: "CITIZENSHIP  EDUCATION II", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: gns_course.id},
  %{code: "GNS 101", title: "USE OF ENGLISH", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: gns_course.id},
  %{code: "GNS 103", title: "USE OF LIBRARY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: gns_course.id},
  %{code: "COM 211", title: "PROGRAMMING USING OO BASIC", units: 3, hours: 30, level: "ND II", program: "ND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 212", title: "SYSTEM PROGRAMMING", units: 3, hours: 30, level: "ND II", program: "ND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 213", title: "PROGRAMMING USING COBOL", units: 3, hours: 30, level: "ND II", program: "ND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 214", title: "FILE MANAGEMENT AND ORGANISATION", units: 3, hours: 30, level: "ND II", program: "ND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 215", title: "COMPUTER APPLICATION PACKAGE II", units: 3, hours: 30, level: "ND II", program: "ND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 216", title: "COMPUTER SYSTEM TROUBLESHOOTING I", units: 3, hours: 30, level: "ND II", program: "ND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 201", title: "USE OF ENGLISH", units: 2, hours: 30, level: "ND II", program: "ND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "EED 216", title: "ENTREPRENURIAL EDUCATION", units: 2, hours: 30, level: "ND II", program: "ND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "SIW 111", title: "SIWES", units: 2, hours: 30, level: "ND II", program: "ND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 221", title: "PROGRAMMING USING OO FORTRAN", units: 3, hours: 30, level: "ND II", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 222", title: "SEMINAR", units: 2, hours: 30, level: "ND II", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 223", title: "BASIC HARDWARE MAINTENANCE", units: 3, hours: 30, level: "ND II", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 214", title: "INFORMATION AND MANAGEMENT SYSTEM", units: 3, hours: 30, level: "ND II", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 225", title: "WEB TECHNOLOGY", units: 3, hours: 30, level: "ND II", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 226", title: "SYSTEM TROUBLESHOOTING", units: 3, hours: 30, level: "ND II", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 229", title: "PROJECT", units: 4, hours: 30, level: "ND II", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 226", title: "SMALL BUSINESS STARTUP", units: 3, hours: 30, level: "ND II", program: "ND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 311", title: "OPERATING SYSTEM", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 312", title: "DATABASE DESIGN I", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 313", title: "COMPUTER PROGRAMMING", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 314", title: "COMPUTER ARCHITECTURE", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 314", title: "OPERATION RESEARCH", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 311", title: "STATISTIC THEORY", units: 2, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 315", title: "BUSINESS COMMUNICATION I", units: 2, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "EED 314", title: "ENTRENEURSHIP", units: 2, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 321", title: "OPERATING SYSTEM II", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 322", title: "DATABASE DESIGN II", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 323", title: "ASSEMBLY LANGUAGE", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 324", title: "INTRODUCTION TO SOFTWARE ENGINEERING", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 326", title: "INTRODUCTION TO HUMAN COMPUTER INTERFACE", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "STA 321", title: "STATISTICS II", units: 2, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 412", title: "BUSINESS COMMUNICATION II", units: 2, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "EED 413", title: "ENTREPRENURSHIP", units: 2, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 412", title: "COMPUTER PROGRAMMING OO PASCAL", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 413", title: "PROJECT MANAGEMENT", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 414", title: "COMPILER CONSTRUCTION", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 415", title: "DATA COMMUNICATION IN NETWORK", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 416", title: "MULTIMEDIA", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 411", title: "OPERATIONAL RESEARCH II", units: 2, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 422", title: "COMPUTER GRAPHICS AND ANIMATION", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 423", title: "INTRODUCTION TO ARTIFICIAL INTELLIGENT AND EXPERT SYSTEM", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 424", title: "PROFESSIONAL PRACTICE IN I.T", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 425", title: "SEMINAR ON CURRENT TOPICS IN COMPUTING", units: 3, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 426", title: "SMALL BUSINESS STARTUP", units: 2, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 429", title: "PROJECT", units: 4, hours: 30, level: "HND I", program: "HND", department: "Computer Science", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 311", title: "PRACTICE OF MANAGEMENT", units: 3, hours: 40, level: "HND I", program: "HND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 312", title: "ORGANIZATIONAL BEHAVIOUR I", units: 3, hours: 40, level: "HND I", program: "HND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 313", title: "QUANTITATIVE TECHNIQUES", units: 3, hours: 40, level: "HND I", program: "HND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 316", title: "PUBLIC FINANCE", units: 3, hours: 40, level: "HND I", program: "HND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 314", title: "HUMAN CAPITAL MANAGEMENT I", units: 3, hours: 40, level: "HND I", program: "HND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "MKT 316", title: "MARKETING MANAGEMENT I", units: 3, hours: 40, level: "HND I", program: "HND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 315", title: "BUSINESS COMMUNICATION", units: 3, hours: 40, level: "HND I", program: "HND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 317", title: "ICT APPLICATION", units: 3, hours: 40, level: "HND I", program: "HND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 321", title: "MANAGEMENT INFORMATION SYSTEM", units: 4, hours: 40, level: "HND I", program: "HND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 322", title: "ORGANIZATIONAL BEHAVIOUR II", units: 3, hours: 40, level: "HND I", program: "HND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 323", title: "MANAGEMENT OF DEVELOPMENT", units: 3, hours: 40, level: "HND I", program: "HND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "ACC 324", title: "HUMAN CAPITAL MANAGEMENT II", units: 3, hours: 40, level: "HND I", program: "HND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 325", title: "PRODUCTION MANAGEMENT", units: 3, hours: 40, level: "HND I", program: "HND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 327", title: "RESEARCH METHODOLOGY", units: 4, hours: 40, level: "HND I", program: "HND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "MKT 328", title: "MARKETING MANAGEMENT II", units: 3, hours: 40, level: "HND I", program: "HND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 329", title: "BUSINESS FINANCE", units: 3, hours: 40, level: "HND I", program: "HND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 101", title: "USE OF ENGLISH I", units: 3, hours: 45, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 111", title: "CITIZENSHIP EDUCATION I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: gns_course.id},
  %{code: "BAM 111", title: "INTRODUCTION TO BUSINESS", units: 2, hours: 30, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 111", title: "SHORTHAND I", units: 4, hours: 60, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 113", title: "INFORMATION AND COMMUNICATION TECH I", units: 6, hours: 90, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 114", title: "OFFICE PRACTICE I", units: 4, hours: 60, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 112", title: "KEYBOARDING I", units: 4, hours: 60, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 103", title: "BASIC FRENCH I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 103", title: "USE OF LIBRARY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 102", title: "USE OF ENGLISH II", units: 3, hours: 45, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: gns_course.id},
  %{code: "OTM 123", title: "INFORMATION AND COMMUNICATION TECH II", units: 6, hours: 90, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 121", title: "CITIZENSHIP EDUCATION II", units: 2, hours: 30, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: gns_course.id},
  %{code: "EED 126", title: "INTRODUCTION TO ENTREPRENEURSHIP", units: 2, hours: 30, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 113", title: "PRINCIPLES OF LAW", units: 2, hours: 30, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 125", title: "CAREER DEVELOPMENT", units: 3, hours: 45, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 121", title: "SHORTHAND II", units: 4, hours: 60, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 124", title: "MODERN OFFICE TECHNOLOGY", units: 3, hours: 45, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 122", title: "KEYBOARDING II", units: 4, hours: 60, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 104", title: "BASIC FRENCH II", units: 2, hours: 30, level: "ND I", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 201", title: "USE OF ENGLISH II", units: 3, hours: 45, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 228", title: "RESEARCH TECHNIQUES", units: 2, hours: 30, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: gns_course.id},
  %{code: "OTM 211", title: "SHORTHAND III", units: 4, hours: 60, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 214", title: "OFFICE PRACTICE II", units: 4, hours: 60, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 213", title: "DESKTOP PUBLISHING", units: 6, hours: 90, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "ACC 111", title: "PRINCIPLES OF ACCOUNTS", units: 2, hours: 30, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 212", title: "KEYBOARDING III", units: 4, hours: 60, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 203", title: "FRENCH III", units: 2, hours: 30, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 271", title: "LAW AND PRACTICE OF MEETING", units: 3, hours: 45, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 323", title: "INTRODUCTION TO PSYCHOLOGY", units: 2, hours: 30, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: gns_course.id},
  %{code: "EED 216", title: "ENTREPRENUERSHIP DEVELOPMENT", units: 2, hours: 30, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 202", title: "COMMUNICATION IN ENGLISH II", units: 3, hours: 45, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 222", title: "RECORDS MANAGEMENT", units: 2, hours: 45, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 114", title: "PRINCIPLES OF ECONOMICS", units: 2, hours: 30, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 223", title: "WEB PAGE DESIGN", units: 6, hours: 90, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 221", title: "PEOPLE COMMUNICATION SKILLS", units: 4, hours: 60, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 227", title: "SIWES", units: 2, hours: 45, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 225", title: "PROJECT", units: 4, hours: 60, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 204", title: "FRENCH IV", units: 2, hours: 30, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 230", title: "SECRETARIAL DUTIES", units: 3, hours: 45, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 128", title: "PRINCIPLES OF MANAGEMENT", units: 2, hours: 60, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 226", title: "SMALL BUSINESS MANAGEMENT", units: 2, hours: 30, level: "ND II", program: "ND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 311", title: "SHORTHAND III", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 313", title: "ICT OFFICE APPLICATION I", units: 8, hours: 120, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 314", title: "OFFICE ADMINISTRATION AND MGT I", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 312", title: "BUSINESS COMMUNICATION I", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 411", title: "SOCIAL PSYCHOLOGY", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "1st", course_category_id: gns_course.id},
  %{code: "BAM 214", title: "BUSINESS LAW", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 326", title: "HUMAN CAPITAL DEVELOPMENT", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 322", title: "PROFESSIONAL CAREER DEVELOPMENT", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 323", title: "ICT OFFICE APPLICATIONS II", units: 8, hours: 120, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 324", title: "OFFICE ADMINISTRATION AND MGT II", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 325", title: "RESEARCH METHOD", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "EED 413", title: "ENTREPRENEURSHIP", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 427", title: "NIGERIAN LABOUR LAW", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 411", title: "ADVANCE TRANSCRIPTION", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 412", title: "BUSINESS COMMUNICATION II", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 413", title: "DATABASE MANAGEMENT SYSTEM", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 414", title: "ORAL COMMUNICATION SKILLS", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 324", title: "ELEMENT OF HUMAN RESOURCE DEV.", units: 3, hours: 45, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 415", title: "ADVANCE DESKTOP PUBLISHING", units: 6, hours: 90, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "OTM 423", title: "MANAGEMENT INFORMATION SYSTEMS", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 424", title: "PROF. ETHICS AND SOCIAL RESPONSIBILITY", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 425", title: "ADVANCE WEB PAGE DESIGN", units: 8, hours: 120, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 422", title: "PROJECT", units: 4, hours: 90, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 411", title: "BUSINESS POLICY & STRATEGY 1", units: 3, hours: 60, level: "HND I", program: "HND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 412", title: "MANAGERIAL ECONOMICS 1", units: 3, hours: 60, level: "HND I", program: "HND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 413", title: "ENTREPRENEURSHIP DEVELOPMENT", units: 4, hours: 60, level: "HND I", program: "HND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 414", title: "INDUSTRIAL RELATIONS", units: 3, hours: 60, level: "HND I", program: "HND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 418", title: "SMALL BUSINESS MANAGEMENT", units: 4, hours: 60, level: "HND I", program: "HND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 401", title: "COMMUNICATION IN ENGLISH", units: 2, hours: 60, level: "HND I", program: "HND", department: "Business Administration", semester: "1st", course_category_id: gns_course.id},
  %{code: "PAS 412", title: "PURCHASING & MATERIAL MGT.", units: 3, hours: 60, level: "HND I", program: "HND", department: "Business Administration", semester: "1st", course_category_id: core_course.id},
  %{code: "BAM 421", title: "BUSINESS POLICY & STRATEGY II", units: 3, hours: 60, level: "HND I", program: "HND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 422", title: "MANAGERIAL ECONOMICS II", units: 3, hours: 60, level: "HND I", program: "HND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 423", title: "INTERNATIONAL BUSINESS", units: 3, hours: 60, level: "HND I", program: "HND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 424", title: "COMPANY LAW", units: 3, hours: 60, level: "HND I", program: "HND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "MKT 402", title: "SALES MANAGEMENT", units: 3, hours: 60, level: "HND I", program: "HND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 425", title: "MANAGERIAL REWARDS", units: 3, hours: 60, level: "HND I", program: "HND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 415", title: "PROJECT", units: 5, hours: 60, level: "HND I", program: "HND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 101", title: "USE OF ENGLISH I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 120", title: "CONTEMPORARY SOCIAL PROBLEMS AND HISTORY OF NIGERIA", units: 2, hours: 30, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "1st", course_category_id: gns_course.id},
  %{code: "STA 111", title: "INTRODUCTION TO STATISTICS", units: 2, hours: 30, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MTH 112", title: "ALGEBRA AND ELEMENTARY TRIGONOMETRY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "CHM 101", title: "CHEMISTRY I", units: 3, hours: 45, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "EEC 112", title: "ELECTRICAL ENGINEERING SCIENCE", units: 3, hours: 45, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 101", title: "TECHNICAL DRAWING", units: 2, hours: 30, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 103", title: "MECHANICAL ENGINEERING SCIENCE", units: 3, hours: 45, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "FDT 111", title: "BASIC FOUNDRY WORKSHOP PRACTICE", units: 2, hours: 30, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 102", title: "COMMUNICATION IN ENGLISH 1", units: 2, hours: 30, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "2nd", course_category_id: gns_course.id},
  %{code: "GNS 125", title: "ECONOMICS", units: 2, hours: 30, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "2nd", course_category_id: gns_course.id},
  %{code: "MTH 122", title: "TRIGONOMETRY AND GEOMETRY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 102", title: "DESCRIPTIVE GEOMETRY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "FDT 121", title: "MATERIAL SCIENCE 1", units: 3, hours: 45, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "FDT 122", title: "METALLURGICAL THERMODYNAMICS", units: 2, hours: 30, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "FDT 123", title: "PRINCIPLES OF PHYSICAL METALLURGY", units: 3, hours: 45, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "FDT 124", title: "MOULDING PRACTICE", units: 2, hours: 30, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "FDT 125", title: "PATTERN PRODUCTION", units: 2, hours: 30, level: "ND I", program: "ND", department: "Foundry Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 101", title: "USE OF ENGLISH", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 127", title: "CITIZENSHIP EDUCATION", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "1st", course_category_id: gns_course.id},
  %{code: "MTH 112", title: "ALGEBRA & ELEMENTARY TRIGONOMETRY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "STAT 111", title: "INTRODUCTION TO STATISTICS", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 101", title: "TECHNICAL DRAWING", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 107", title: "MECHANICAL ENGINEERING SCIENCE", units: 3, hours: 45, level: "ND I", program: "ND", department: "Computer Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 104", title: "MECHANICAL WORKSHOP TECH.& PRACTICE 1CE", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "EEC 116", title: "ELECTRICAL WORKSHOP PRACTICE 1", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 111", title: "INTRODUCTION TO COMPUTER", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 114", title: "TECHNICAL REPORT WRITING", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "EEC 112", title: "ELECTRICAL ENGINEERING SCIENCE", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 102", title: "COMMUNICATION IN ENGLISH 1", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "2nd", course_category_id: gns_course.id},
  %{code: "GNS 125", title: "ECONOMICS", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "2nd", course_category_id: gns_course.id},
  %{code: "MTH 211", title: "CALCULUS", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 102", title: "DESCRIPTIVE GEOMETRY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 108", title: "INTRODUCTION TO THERMODYNAMICS", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "EEC 124", title: "ELECTRONICS 1", units: 3, hours: 45, level: "ND I", program: "ND", department: "Computer Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "EEC 126", title: "ELECTRICAL WORKSHOP PRACTICE II", units: 1, hours: 15, level: "ND I", program: "ND", department: "Computer Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "EEC 128", title: "ELECTRICAL MEASURMENT AND INSTRUMENTATION E II", units: 3, hours: 45, level: "ND I", program: "ND", department: "Computer Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 122", title: "COMPUTER OPERATIONS", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "COM 221", title: "COMPUTER PROGRAMMING (FORTRAN)", units: 3, hours: 45, level: "ND I", program: "ND", department: "Computer Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "EED 126", title: "INTRODUCTION TO ENTERRPENEURTRAN)", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "CTE 121", title: "DIGITAL COMPUTER FUNDAMENTALS IURTRAN)", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 401", title: "LIFE AND GENERAL DRAWING[SCULTURE]", units: 1, hours: 15, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 403", title: "COSTING AND ESTIMATING[SCULTURE]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "SCU 401", title: "METHODS MATERIALS III[SCULTURE]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "SCU 403", title: "MODELLING III[SCULTURE]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "SCU 405", title: "CARVING III[SCULTURE]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "SCU 407", title: "CASTING TECHNIQUE III[SCULTURE]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "SCU 409", title: "CONSTRUCTION III[SCULTURE]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 311", title: "COMPUTER PROGRAMMING[SCULTURE]", units: 3, hours: 45, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 401", title: "LIFE AND GENERAL DRAWING[GRAPHICS]", units: 1, hours: 15, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 403", title: "COSTING AND ESTIMATING[GRAPHICS]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "GRA 401", title: "REPROMETHODS[GRAPHICS]", units: 3, hours: 45, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "GRA 403", title: "PUBLICITY/ADVERTISING [GRAPHICS]", units: 3, hours: 45, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "GRA 405", title: "ILLUSTRATION[GRAPHICS]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "GRA 407", title: "PHOTOGRAPHY[GRAPHICS]", units: 3, hours: 45, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "COM 311", title: "COMPUTER PROGRAMMING[GRAPHICS]", units: 3, hours: 45, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "GRA 409", title: "PROJECT[GRAPHICS]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 402", title: "LIFE AND GENERAL DRAWING[SCULTURE]", units: 1, hours: 15, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 404", title: "COSTING AND ESTIMATING[SCULTURE]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "SCU 402", title: "METHODS MATERIALS IV[SCULTURE]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "SCU 404", title: "MODELLING IV[SCULTURE]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "SCU 406", title: "CARVING IV[SCULTURE]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "SCU 408", title: "CASTING TECHNIQUE IV[SCULTURE]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "SCU 410", title: "CONSTRUCTION IV[SCULTURE]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "SCU 412", title: "PROJECT[SCULTURE]", units: 4, hours: 60, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 402", title: "LIFE AND GENERAL DRAWING[GRAPHICS]", units: 1, hours: 15, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 404", title: "COSTING AND ESTIMATING[GRAPHICS]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "GRA 402", title: "REPROMETHODS[GRAPHICS]", units: 3, hours: 45, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "GRA 404", title: "PUBLICITY/ADVERTISING [GRAPHICS]", units: 3, hours: 45, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "GRA 406", title: "ILLUSTRATION[GRAPHICS]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "GRA 408", title: "PHOTOGRAPHY[GRAPHICS]", units: 3, hours: 45, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "GRA 410", title: "PROJECT[GRAPHICS]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "GRA 410", title: "PROJECT[GRAPHICS]", units: 2, hours: 30, level: "HND I", program: "HND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "OTM 402", title: "LITERARY APPRECIATION AND ORAL COMPOSITION", units: 4, hours: 60, level: "HND I", program: "HND", department: "Office Technology and Management", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 101", title: "USE OF ENGLISH", units: 2, hours: 30, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 111", title: "CITIZENSHIP EDUCATION", units: 2, hours: 30, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 103", title: "USE OF LIBRARY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "1st", course_category_id: gns_course.id},
  %{code: "MTH 112", title: "ALGEBRA AND ELEMENTARY TRIGONOMETRY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 111", title: "MECHANICAL ENGINEERING SCIENCE I", units: 4, hours: 60, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 112", title: "TECHNICAL DRAWING", units: 4, hours: 60, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 113", title: "BASIC WORKSHOP TECHNOLOGY AND PRACTICE", units: 3, hours: 45, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "EEC 114", title: "REPORT WRITING", units: 4, hours: 60, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "EEC 112", title: "INTRODUCTION TO COMPUTER SOFTWARE", units: 3, hours: 45, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "EEC 117", title: "COMPUTER HARDWARE I", units: 3, hours: 45, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "EEC 111", title: "ELECTRICAL GRAPHICS", units: 4, hours: 60, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "EEC 115", title: "ELECTRICAL ENGINEERING SCIENCE I", units: 3, hours: 45, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 102", title: "COMMUNICATION SKILLS I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MTH 211", title: "CALCULUS", units: 2, hours: 30, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 123", title: "MACHINE TOOLS TECHNOLOGY AND PRACTICE", units: 3, hours: 45, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 124", title: "MECHANICAL ENGINEERING SCIENCE II", units: 4, hours: 60, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "EEC122", title: "ELECTRICAL POWER I", units: 3, hours: 45, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "EEC 123", title: "ELECTRICAL MACHINE I", units: 3, hours: 45, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "EEC 125", title: "ELECTRICAL ENGINEERING SCIENCE II", units: 3, hours: 45, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "EEC 126", title: "ELECTRICAL AND ELECTRONIC INSTRUMENT I", units: 4, hours: 60, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "EEC 128", title: "TELECOMMUNICATIONS I", units: 3, hours: 45, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "EEC 129", title: "ELECTRICAL INSTALLATION OF BUILDING", units: 3, hours: 45, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "EED 126", title: "ENTREPRENEURSHIP DEVELOPMENT", units: 3, hours: 45, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "FAS 101", title: "FASHION ILLUSTRATION I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "FAS 103", title: "TEXTILE MATERIALS I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "FAS 105", title: "PATTERN DRAFTING I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "FAS 107", title: "CLOTHING CONSTRUCTION I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "FAS 109", title: "HISTORY OF COSTUMES I", units: 1, hours: 15, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 101", title: "BASIC DESIGN I", units: 1, hours: 15, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "ARD 103", title: "LIFE DRAWING I", units: 1, hours: 15, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 101", title: "USE OF ENGLISH I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 120", title: "CITIZEN EDUCATION", units: 2, hours: 30, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: gns_course.id},
  %{code: "CMP 101", title: "INTRODUCTION TO INFORMATION TECH I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 103", title: "USE OF LIBRARY I", units: 1, hours: 15, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "1st", course_category_id: core_course.id},
  %{code: "FAS 102", title: "FASHION ILLUSTRATION 2", units: 2, hours: 30, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "FAS 104", title: "TEXTILE MATERIALS 2", units: 2, hours: 30, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "FAS 106", title: "PATTERN DRAFTING 2", units: 2, hours: 30, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "FAS 108", title: "CLOTHING CONSTRUCTION 2", units: 2, hours: 30, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "FAS 110", title: "HISTORY OF CONSTUMES 2", units: 1, hours: 15, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "ARD 102", title: "LIFE DRAWING 2", units: 1, hours: 15, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 102", title: "COMMUNICATION IN ENGLISH 2", units: 2, hours: 30, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: gns_course.id},
  %{code: "GNS 121", title: "CITIZEN EDUCATION 2", units: 2, hours: 30, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: gns_course.id},
  %{code: "CMP 102", title: "FURTHER INFORMATION TECH 2", units: 2, hours: 30, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "EED 126", title: "INTRODUCTION TO ENTREPRENEURIAL", units: 2, hours: 30, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "FAS 111", title: "INTRO. TO FASHION ACCESSORIES", units: 2, hours: 30, level: "ND I", program: "ND", department: "Fashion Design and Clothing Technology", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 101", title: "USE OF ENGLISH I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 120", title: "CONTEMPORARY SOCIAL PROBLEMS AND OUTLINE HISTORY OF NIGERIA", units: 2, hours: 30, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: gns_course.id},
  %{code: "GNS 103", title: "USE OF LIBRARY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: gns_course.id},
  %{code: "ICT 103", title: "INTRODUCTION TO COMPUTER", units: 2, hours: 30, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "STA 111", title: "INTRODUCTION TO STATISTICS", units: 2, hours: 30, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 113", title: "SAFETY IN WORKSHOP", units: 2, hours: 30, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MTH 112", title: "ALGEBRA AND ELEMENTARY TRIGONOMETRY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "CHM 101", title: "CHEMISTRY I", units: 3, hours: 45, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "EEC 112", title: "ELECTRICAL ENGINEERING SCIENCE", units: 2, hours: 30, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 101", title: "TECHNICAL DRAWING", units: 3, hours: 45, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 103", title: "MECHANICAL ENGINEERING SCIENCE", units: 2, hours: 30, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 102", title: "COMMUNICATION IN ENGLISH", units: 2, hours: 30, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 125", title: "ECONOMICS", units: 2, hours: 30, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: gns_course.id},
  %{code: "MTH 211", title: "CALCULUS", units: 2, hours: 30, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "CHM 102", title: "CHEMISTRY II", units: 3, hours: 45, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 102", title: "DESCRIPTIVE GEOMETRY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MEC 105", title: "BASIC WORKSHOP PRACTICE", units: 3, hours: 45, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MET 102", title: "MATERIAL SCIENCE I", units: 2, hours: 30, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MET 104", title: "PRINCIPLES OF PHYSICAL METALLURGY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "PHE 106", title: "PHYSICAL EDUCATION", units: 2, hours: 30, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "EED 126", title: "ENTREPRENURSHIP DEVELOPMENT", units: 2, hours: 30, level: "ND I", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 201", title: "USE OF ENGLISH II", units: 2, hours: 30, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MTH 211", title: "LOGIC AND LINEAR ALGEBRA", units: 2, hours: 30, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 203", title: "ENGINEERING MEASUREMENT", units: 2, hours: 30, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MEC 205", title: "STRENGTH OF MATERIALS", units: 3, hours: 45, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MET 201", title: "MINERALOGY", units: 2, hours: 30, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MET 203", title: "WORKSHOP TECHNOLOGY", units: 2, hours: 30, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MET 205", title: "PRINCIPLES OF EXTRACTIVE METALLURGY", units: 2, hours: 30, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MET 207", title: "MATERIAS SCIENCE II", units: 2, hours: 30, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "MET 209", title: "PROPERTIES OF MATERIALS", units: 3, hours: 45, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 202", title: "COMMUNICATION IN ENGLISH II", units: 2, hours: 30, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: gns_course.id},
  %{code: "MTH 222", title: "TRIGONOMETRY AND ANALYTICAL GEOMETRY", units: 2, hours: 30, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MET 202", title: "NON METALLIC MATERIALS TECH.", units: 2, hours: 30, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MET 204", title: "METALLOGRAPHY", units: 2, hours: 30, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MET 206", title: "TRANSPORT PROCESSES", units: 2, hours: 30, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MET 208", title: "FOUNTRY TECHNOLOGY", units: 3, hours: 45, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MET 210", title: "PRODUCTION METALLURGY", units: 2, hours: 30, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MET 212", title: "IRON AND STEEL MAKING", units: 2, hours: 30, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "MET 214", title: "FINAL YEAR PROJECT", units: 2, hours: 30, level: "ND II", program: "ND", department: "Metallurgical Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 103", title: "USE OF LIBRARY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Computer Engineering", semester: "1st", course_category_id: gns_course.id},
  %{code: "EEC 124", title: "ELECTRONICS I", units: 3, hours: 45, level: "ND I", program: "ND", department: "Electrical/Electronics Engineering", semester: "2nd", course_category_id: core_course.id},
  %{code: "BAM 122", title: "BUSINESS MATHEMATICES II", units: 3, hours: 30, level: "ND I", program: "ND", department: "Business Administration", semester: "2nd", course_category_id: core_course.id},
  %{code: "GNS 111", title: "CITIZENSHIP EDUCATION", units: 2, hours: 30, level: "ND I", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "GNS 103", title: "USE OF LIBRARY", units: 2, hours: 30, level: "ND I", program: "ND", department: "Mechanical Engineering", semester: "2nd", course_category_id: gns_course.id},
  %{code: "OTM 222", title: "COMMUNICATION SKILLS", units: 2, hours: 30, level: "ND II", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
  %{code: "EED 216", title: "ENTREPRENEURSHIP", units: 2, hours: 30, level: "ND II", program: "ND", department: "Hospitality", semester: "1st", course_category_id: core_course.id},
]


for course <- courses do
  department = Repo.get_by(Department, [name: course[:department]])
  query = from t in Term, join: p in assoc(t, :term_set), where: t.description == ^course[:semester]
  semester = query |> Repo.one

  query = from l in Level, join: p in assoc(l, :program), where: l.description == ^course[:level] and  p.name == ^course[:program]
  level = query |> Repo.one

  course = Map.put(course, :department_id, department.id)
  course = Map.put(course, :level_id, level.id)
  course = Map.put(course, :semester_id, semester.id)


  changeset = Course.changeset(%Course{}, course)
  Repo.insert!(changeset)
end


grades = [
  %{ maximum: 74, minimum: 70, point: 3.5, description: "A"},
   %{ maximum: 100, minimum: 75, point: 4.0, description: "AA"},
   %{ maximum: 69, minimum: 65, point: 3.25, description: "AB"},
   %{ maximum: 64, minimum: 60, point: 3.0, description: "B"},
   %{ maximum: 59, minimum: 55, point: 2.75, description: "BC"},
   %{ maximum: 54, minimum: 50, point: 2.5, description: "C"},
   %{ maximum: 49, minimum: 45, point: 2.25, description: "CD"},
   %{ maximum: 44, minimum: 40, point: 2.0, description: "D"},
   %{ maximum: 39, minimum: 0, point: 0.0, description: "F"}
]

for grade <- grades do
  if(Repo.get_by(Grade, [maximum: grade[:maximum], minimum: grade[:minimum]]) == nil) do
    changeset = Grade.changeset(%Grade{}, grade)
    Repo.insert!(changeset)
  end
end

{_, opening_date} = Ecto.Date.cast("2016-05-01")
{_, closing_date} = Ecto.Date.cast("2016-12-20")
academic_session_params = %{description: "2016/2017", opening_date: opening_date, closing_date: closing_date, active: true}
if Repo.get_by(AcademicSession, [description: "2016/2017"]) == nil do
  changeset = AcademicSession.changeset(%AcademicSession{},academic_session_params)
  if changeset.valid?, do: Repo.insert!(changeset)
end
academic_session_params = %{description: "2017/2018", opening_date: "2016-08-10", closing_date: closing_date, active: false}
if Repo.get_by(AcademicSession, [description: "2017/2018"]) == nil do
  changeset = AcademicSession.changeset(%AcademicSession{},academic_session_params)
  if changeset.valid?, do: Repo.insert!(changeset)
end


program = Repo.get_by(Program, name: "ND")
department = Repo.get_by(Department, [name: "Mechanical Engineering"])
level = Repo.get_by(Level, description: "ND I")
gender = Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Male" and ts.name == ^"gender")
marital_status = Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Single" and ts.name == ^"marital_status")
entry_mode = Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Post UTME" and ts.name == ^"entry_mode")
academic_session = Repo.get_by(AcademicSession, [description: "2016/2017", active: true])
level = Repo.get_by(Level, description: "ND I")
semester = Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"1st" and ts.name == ^"semester")
local_government_area = LocalGovernmentArea |> Repo.all |> Enum.random



user_category = Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Applicant" and ts.name == ^"user_category")
registration_no = "DS151690003478"
user = %{user_name: String.downcase(registration_no), email: "jane.brown@dspg.edu.ng", password: "password", user_category_id: user_category.id}
if Repo.get_by(User, [user_name: user.user_name]) == nil do
  changeset = User.changeset(%User{}, user)
  if changeset.valid? do
    {:ok, user} = Repo.insert(changeset)
    student = %{first_name: "Jane", last_name: "Brown", email: "jane.brown@dspg.edu.ng", registration_no: registration_no, program_id: program.id, department_id: department.id, entry_mode_id: entry_mode.id, user_id: user.id, academic_session_id: academic_session.id, level_id: level.id, local_government_area_id: local_government_area.id}
    changeset = Student.changeset(%Student{}, student)
    if changeset.valid?, do: Repo.insert!(changeset)
  end
end

local_government_area = LocalGovernmentArea |> Repo.all |> Enum.random
registration_no = "DS151690003470"
user_category = Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"user_category")
User.changeset(%User{}, %{user_name: String.downcase(registration_no), email: "ufuoma.brown@walden.edu.ng", password: "password", user_category_id: user_category.id})
|> Repo.insert()
|> case do
    {:ok, user} ->
      Student.changeset(%Student{}, %{first_name: "Ufuoma", last_name: "Brown", email: "ufuoma.brown@walden.edu.ng", registration_no: registration_no, program_id: program.id, department_id: department.id, user_id: user.id, level_id: level.id, gender_id: gender.id, marital_status_id: marital_status.id, entry_mode_id: entry_mode.id, academic_session_id: academic_session.id, local_government_area_id: local_government_area.id})
      |> Repo.insert()
      |> case do
         {:ok, student} -> register_courses.(student)
         _ -> IO.inspect "failed to create student #{registration_no}"
      end
    _ -> IO.inspect "failed to create user #{registration_no}"
end

local_government_area = LocalGovernmentArea |> Repo.all |> Enum.random
registration_no = "DS151690003477"
if Repo.get_by(User, [user_name: String.downcase(registration_no)]) == nil do
  changeset = User.changeset(%User{}, %{user_name: String.downcase(registration_no), email: "brown.fish@dspg.edu.ng", password: "password", user_category_id: user_category.id})
  if changeset.valid? do
    {:ok, user} = Repo.insert(changeset)
    student = %{first_name: "Brown", last_name: "Fish", email: "brown.fish@dspg.edu.ng", registration_no: registration_no, program_id: program.id, department_id: department.id, user_id: user.id, level_id: level.id, gender_id: gender.id, marital_status_id: marital_status.id, entry_mode_id: entry_mode.id, academic_session_id: academic_session.id, local_government_area_id: local_government_area.id}
    changeset = Student.changeset(%Student{}, student)
    if changeset.valid? do
      {:ok, student} = Repo.insert(changeset)
      register_courses.(student)
    end

  end
end

[
%{user_name: "DS151690003477", role: "Student", default: true},
%{user_name: "DS151690003478", role: "Applicant", default: true}
]
|> Enum.each(&(assign_role.(&1)))

user_category = Repo.all(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Staff" and ts.name == ^"user_category") |> List.first
users = [
  %{user_name: String.downcase("WLD/STF/000301"), email: "evragab@walden.edu.ng", password: "password", user_category_id: user_category.id},
  %{user_name: String.downcase("WLD/STF/000300"), email: "smithaitufe@walden.edu.ng", password: "password", user_category_id: user_category.id},
  %{user_name: String.downcase("WLD/STF/000302"), email: "jun.gospel@walden.edu.ng", password: "password", user_category_id: user_category.id},
  %{user_name: String.downcase("WLD/STF/000303"), email: "efemena.agbi@walden.edu.ng", password: "password", user_category_id: user_category.id},
  %{user_name: String.downcase("WLD/STF/000304"), email: "thankgod.goodwill@walden.edu.ng", password: "password", user_category_id: user_category.id},
  %{user_name: String.downcase("WLD/STF/000305"), email: "stephen.oboh@walden.edu.ng", password: "password", user_category_id: user_category.id},
  %{user_name: String.downcase("WLD/STF/000306"), email: "ogechi.onouha@walden.edu.ng", password: "password", user_category_id: user_category.id},
  %{user_name: String.downcase("WLD/STF/000307"), email: "juliet.jeb@walden.edu.ng", password: "password", user_category_id: user_category.id},
  %{user_name: String.downcase("WLD/STF/000308"), email: "uche.okeke@walden.edu.ng", password: "password", user_category_id: user_category.id},
  %{user_name: String.downcase("WLD/STF/000309"), email: "jose.conte@walden.edu.ng", password: "password", user_category_id: user_category.id},
]
Enum.each(users, fn user ->
%User{}
|> User.changeset(user)
|> Repo.insert()
end)



department_type = Repo.one(Term |> Ecto.Query.join(:inner, [t], ts in assoc(t, :term_set)) |> Ecto.Query.where([t, ts], ts.name == ^"department_type" and t.description == ^"Non Academic"))
academic_department = Repo.one(Term |> Ecto.Query.join(:inner, [t], ts in assoc(t, :term_set)) |> Ecto.Query.where([t, ts], ts.name == ^"department_type" and t.description == ^"Academic"))
[
  %{title: "Bursar", description: "The Bursar is responsible to the Rector on all financial matters in the Polytechnic. He is the custodian of the Polytechnic’s financial records and plans organize and coordinate the operation of the financial system of the Polytechnic", department_type_id: department_type.id},
  %{title: "The Polytechnic Librarian", description: "The Polytechnic Librarian is responsible to the Rector for the administration and smooth operation of the Library services of the Polytechnic. He shall possess those personal qualities like drive, innovation, resourcefulness and ability to initiate and supervise research", department_type_id: department_type.id},
  %{title: "Director of Medical Services", description: "The Director Medical Services Is responsible for the administration of medical services in the polytechnic. He shall be in charge of all the Clinics and All matters that relates to medical care.", department_type_id: department_type.id},
  %{title: "Director of Works and Maintenance Services", description: "The Director of Works and Maintenance shall be the overall controller of the Works and Estate Department", department_type_id: department_type.id},
  %{title: "Lecturer I", description: "The position of Lecturer I is that of teaching pupils", department_type_id: academic_department.id},
  %{title: "Lecturer II", description: "The position of Lecturer II is that of teaching pupils", department_type_id: academic_department.id},
  %{title: "Senior Lecturer", description: "The position of Senior Lecturer is that of teaching pupils", department_type_id: academic_department.id},
  %{title: "Principal Lecturer", description: "The position of Principal Lecturer is that of teaching pupils", department_type_id: academic_department.id}
]
|> Enum.each(fn job ->
  %Job{}
  |> Job.changeset(job)
  |> Repo.insert()
end)

salary_structure_types = ["CONPCASS","CONTEDISS"]
for st <- salary_structure_types do
  salary_structure_type = Term
  |> Ecto.Query.join(:inner, [t], ts in assoc(t, :term_set))
  |> Ecto.Query.where([t,ts], t.description == ^st and ts.name == ^"salary_structure_type")
  |> Repo.all
  |> List.first
  start = 0
  stop  = 0
  case st do
    "CONPCASS" ->
      start = 7
      stop = 15
    "CONTEDISS" ->
      start = 1
      stop = 15
  end

  for i <- start..stop do
    description = i |> Integer.to_string |> String.rjust(2, ?0)
    if st == "CONPCASS" && i != 11 do
      grade_level = %{description: description, salary_structure_type_id: salary_structure_type.id}
      changeset = SalaryGradeLevel.changeset(%SalaryGradeLevel{}, grade_level)
      if changeset.valid? do
        {:ok, salary_grade_level} = Repo.insert(changeset)
        cond do
          i <= 9 -> steps = 1..15
          i >= 10 && i < 12 -> steps = 1..11
          true -> steps = 1..9
        end
        for s <- steps do
          gs = s |> Integer.to_string |> String.rjust(2, ?0)
          grade_step = %{description: gs, salary_grade_level_id: salary_grade_level.id}
          changeset = SalaryGradeStep.changeset(%SalaryGradeStep{}, grade_step)
          if changeset.valid? do
            {:ok, grade_step} = Repo.insert(changeset)
          end
        end
      end
    else if st == "CONTEDISS" && i != 10  do
      grade_level = %{description: description, salary_structure_type_id: salary_structure_type.id}
      changeset = SalaryGradeLevel.changeset(%SalaryGradeLevel{}, grade_level)
        if changeset.valid? do
          {:ok, salary_grade_level} = Repo.insert(changeset)
          cond do
            i <= 9 -> steps = 1..15
            i >= 11 && i <= 12 -> steps = 1..11
            i >= 13 && i <= 15 -> steps = 1..9

          end
          for s <- grade_steps do
            gs = s |> Integer.to_string |> String.rjust(2, ?0)
            grade_step = %{description: gs, salary_grade_level_id: salary_grade_level.id}
            changeset = SalaryGradeStep.changeset(%SalaryGradeStep{}, grade_step)
            if changeset.valid? do
              {:ok, grade_step} = Repo.insert(changeset)
            end
          end
        end
      end
    end
  end
end


staff_1_user = Repo.get_by(User, [user_name: String.downcase("WLD/STF/000300")])
staff_2_user = Repo.get_by(User, [user_name: String.downcase("WLD/STF/000302")])
staff_3_user = Repo.get_by(User, [user_name: String.downcase("WLD/STF/000303")])
staff_4_user = Repo.get_by(User, [user_name: String.downcase("WLD/STF/000304")])
staff_5_user = Repo.get_by(User, [user_name: String.downcase("WLD/STF/000305")])
staff_6_user = Repo.get_by(User, [user_name: String.downcase("WLD/STF/000306")])
staff_7_user = Repo.get_by(User, [user_name: String.downcase("WLD/STF/000307")])
staff_8_user = Repo.get_by(User, [user_name: String.downcase("WLD/STF/000308")])
staff_9_user = Repo.get_by(User, [user_name: String.downcase("WLD/STF/000309")])

[
  %{first_name: "Clinton", last_name: "John", email: "john.clinton@walden.edu.ng", registration_no: "WLD/STF/000300", user_id: staff_1_user.id, gender_id: gender.id, marital_status_id: marital_status.id},
  %{first_name: "Gospel", last_name: "Junior", email: "jun.gospel@walden.edu.ng", registration_no: "WLD/STF/000302", user_id: staff_2_user.id, gender_id: gender.id, marital_status_id: marital_status.id},
  %{first_name: "Efemena", last_name: "Agbi", email: "efemena.abi@walden.edu.ng", registration_no: "WLD/STF/000303", user_id: staff_3_user.id, gender_id: gender.id, marital_status_id: marital_status.id},
  %{first_name: "ThankGod", last_name: "Goodwill", email: "thankgod.goodwill@walden.edu.ng", registration_no: "WLD/STF/000304", user_id: staff_4_user.id, gender_id: gender.id, marital_status_id: marital_status.id},
  %{first_name: "Stephen", last_name: "Oboh", email: "stephen.oboh@walden.edu.ng", registration_no: "WLD/STF/000305", user_id: staff_5_user.id, gender_id: gender.id, marital_status_id: marital_status.id},
  %{first_name: "Ogechi", last_name: "Onouha", email: "ogechi.onouha@walden.edu.ng", registration_no: "WLD/STF/000306", user_id: staff_6_user.id, gender_id: gender.id, marital_status_id: marital_status.id},
  %{first_name: "Juliet", last_name: "Jeb", email: "juliet.jeb@walden.edu.ng", registration_no: "WLD/STF/000307", user_id: staff_7_user.id, gender_id: gender.id, marital_status_id: marital_status.id},
  %{first_name: "Uche", last_name: "Okeke", email: "uche.okeke@walden.edu.ng", registration_no: "WLD/STF/000308", user_id: staff_8_user.id, gender_id: gender.id, marital_status_id: marital_status.id},
  %{first_name: "Jose", last_name: "Conte", email: "jose.conte@walden.edu.ng", registration_no: "WLD/STF/000309", user_id: staff_9_user.id, gender_id: gender.id, marital_status_id: marital_status.id}
]
|> Enum.each(&(
%Staff{}
|> Staff.changeset(&1)
|> Repo.insert!()
))

[
  %{user_name: "WLD/STF/000300", role: "Lecturer", default: true},
  %{user_name: "WLD/STF/000301", role: "Lecturer", default: true},
  %{user_name: "WLD/STF/000302", role: "Lecturer", default: true},
  %{user_name: "WLD/STF/000303", role: "Lecturer", default: true},
  %{user_name: "WLD/STF/000304", role: "Lecturer", default: true},
  %{user_name: "WLD/STF/000305", role: "Lecturer", default: true},
  %{user_name: "WLD/STF/000305", role: "FacultyHead", default: false},
  %{user_name: "WLD/STF/000302", role: "DepartmentHead", default: false},
  %{user_name: "WLD/STF/000307", role: "Registry", default: true},
  %{user_name: "WLD/STF/000308", role: "RegistryAssist", default: true},
  %{user_name: "WLD/STF/000309", role: "RegistryOfficer", default: false}
]
|> Enum.each(&(assign_role.(&1)))

staff_posting.(%{user: staff_1_user, job_title: "Lecturer I", department_name: "Mechanical Engineering", posted_date: "2016-08-04", effective_date: "2016-09-01"})
staff_posting.(%{user: staff_2_user, job_title: "Lecturer II", department_name: "Mechanical Engineering", posted_date: "2016-08-04", effective_date: "2016-09-01"})
staff_posting.(%{user: staff_3_user, job_title: "Lecturer II", department_name: "Mechanical Engineering", posted_date: "2016-08-04", effective_date: "2016-09-01"})
staff_posting.(%{user: staff_4_user, job_title: "Principal Lecturer", department_name: "Mechanical Engineering", posted_date: "2016-08-04", effective_date: "2016-09-01"})
staff_posting.(%{user: staff_5_user, job_title: "Principal Lecturer", department_name: "Mechanical Engineering", posted_date: "2016-08-04", effective_date: "2016-09-01"})



assign_office_head.(%{type: "faculty", user: staff_5_user, name: "School of Engineering", appointment_date: "2016-12-20", effective_date: "2017-02-01", end_date: "2018-05-30", active: true})
assign_office_head.(%{type: "department", user: staff_2_user, name: "Mechanical Engineering", appointment_date: "2016-12-20", effective_date: "2017-02-01", end_date: "2018-05-30", active: true})

academic_session = Repo.get_by(AcademicSession, [description: "2017/2018"])
course = Repo.get_by(Course, [code: "MEC 211"])
staff = Repo.get_by(Staff, [registration_no: "WLD/STF/000302"])
%CourseTutor{}
|> CourseTutor.changeset(%{course_id:  course.id, staff_id: staff.id, academic_session_id: academic_session.id})
|> Repo.insert!()

fees = [
  %{code: "200", description: "ND Application Fee", amount: 2000, service_charge: 1000, program_id: Repo.get_by(Program, [name: "ND"]).id, is_catchment_area: false, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Applicant" and ts.name == ^"fee_category").id },
  %{code: "201", description: "HND Application Fee", amount: 8000, service_charge: 1000, program_id: Repo.get_by(Program, [name: "HND"]).id, is_catchment_area: false, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Applicant" and ts.name == ^"fee_category").id },
  %{code: "202", description: "ND Acceptance Fee", amount: 10000, service_charge: 1000, program_id: Repo.get_by(Program, [name: "ND"]).id, is_catchment_area: false, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id },
  %{code: "203", description: "HND Acceptance Fee", amount: 14000, service_charge: 1000, program_id: Repo.get_by(Program, [name: "HND"]).id, is_catchment_area: false, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id },
  %{code: "204", description: "ND I School Fee", amount: 24000, service_charge: 1500, program_id: Repo.get_by(Program, [name: "ND"]).id, level_id: Repo.get_by(Level, [description: "ND I"]).id,  is_catchment_area: true, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id },
  %{code: "205", description: "ND I School Fee", amount: 27000, service_charge: 1500, program_id: Repo.get_by(Program, [name: "ND"]).id, level_id: Repo.get_by(Level, [description: "ND I"]).id,  is_catchment_area: false, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id },
  %{code: "206", description: "ND II School Fee", amount: 23000, service_charge: 1500, program_id: Repo.get_by(Program, [name: "ND"]).id, level_id: Repo.get_by(Level, [description: "ND II"]).id,  is_catchment_area: true, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id },
  %{code: "207", description: "ND II School Fee", amount: 27000, service_charge: 1500, program_id: Repo.get_by(Program, [name: "ND"]).id, level_id: Repo.get_by(Level, [description: "ND II"]).id,  is_catchment_area: false, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id },
  %{code: "208", description: "HND I School Fee", amount: 29000, service_charge: 1500, program_id: Repo.get_by(Program, [name: "HND"]).id, level_id: Repo.get_by(Level, [description: "HND I"]).id,  is_catchment_area: true, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id },
  %{code: "209", description: "HND I School Fee", amount: 32000, service_charge: 1500, program_id: Repo.get_by(Program, [name: "HND"]).id, level_id: Repo.get_by(Level, [description: "HND I"]).id,  is_catchment_area: false, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id },
  %{code: "210", description: "HND II School Fee", amount: 34500, service_charge: 1500, program_id: Repo.get_by(Program, [name: "HND"]).id, level_id: Repo.get_by(Level, [description: "HND II"]).id,  is_catchment_area: true, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id },
  %{code: "211", description: "HND II School Fee", amount: 37500, service_charge: 1500, program_id: Repo.get_by(Program, [name: "HND"]).id, level_id: Repo.get_by(Level, [description: "HND II"]).id,  is_catchment_area: false, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id },
  %{code: "212", description: "ND I School Fee", amount: 24000, service_charge: 1500, program_id: Repo.get_by(Program, [name: "ND"]).id, level_id: Repo.get_by(Level, [description: "ND I"]).id,  is_catchment_area: true, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id },
  %{code: "213", description: "ND II School Fee", amount: 23000, service_charge: 1500, program_id: Repo.get_by(Program, [name: "ND"]).id, level_id: Repo.get_by(Level, [description: "ND II"]).id,  is_catchment_area: true, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id },
  %{code: "214", description: "HND I School Fee", amount: 29000, service_charge: 1500, program_id: Repo.get_by(Program, [name: "HND"]).id, level_id: Repo.get_by(Level, [description: "HND I"]).id,  is_catchment_area: true, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id },
  %{code: "216", description: "HND II School Fee", amount: 34500, service_charge: 1500, program_id: Repo.get_by(Program, [name: "HND"]).id, level_id: Repo.get_by(Level, [description: "HND II"]).id,  is_catchment_area: true, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id },
  %{code: "219", description: "ND I School Fee", amount: 27000, service_charge: 1500, program_id: Repo.get_by(Program, [name: "ND"]).id, level_id: Repo.get_by(Level, [description: "ND I"]).id,  is_catchment_area: false, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id },
  %{code: "220", description: "ND II School Fee", amount: 27000, service_charge: 1500, program_id: Repo.get_by(Program, [name: "ND"]).id, level_id: Repo.get_by(Level, [description: "ND II"]).id,  is_catchment_area: false, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id },
  %{code: "221", description: "HND I School Fee", amount: 32000, service_charge: 1500, program_id: Repo.get_by(Program, [name: "HND"]).id, level_id: Repo.get_by(Level, [description: "HND I"]).id,  is_catchment_area: false, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id },
  %{code: "222", description: "HND II School Fee", amount: 37500, service_charge: 1500, program_id: Repo.get_by(Program, [name: "HND"]).id, level_id: Repo.get_by(Level, [description: "HND II"]).id,  is_catchment_area: false, fee_category_id: Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"Student" and ts.name == ^"fee_category").id }
]
for fee <- fees do
  if Repo.get_by(Fee, code: fee.code) == nil do
    changeset = Fee.changeset(%Fee{}, fee)
    if changeset.valid?, do: Repo.insert!(changeset)
  end
end
transaction_responses = [
  %{code: "Z4", description: "Interface Integration Error"},
  %{code: "51", description: "Insufficient Funds"},
  %{code: "41", description: "Lost(Card, Pick - Up)"},
  %{code: "Z6", description: "Incomplete(Transaction)"},
  %{code: "Z1", description: "Incorrect PIN"},
  %{code: "59", description: "Suspected Fraud"},
  %{code: "54", description: "Expired Card"},
  %{code: "00", description: "Approved Successful"},
  %{code: "91", description: "Issuer or Switch Inoperative"},
  %{code: "59", description: "Unable to process CVV2"},
  %{code: "Z5", description: "Duplicate Reference Error"},
  %{code: "00", description: "Approved Successfuf"},
  %{code: "57", description: "Transaction not permitted to Cardholder"},
  %{code: "Z6", description: "Customer cancellation"},
  %{code: "04", description: "Pick-up card"},
  %{code: "43", description: "Stolen Card, Pick-Up"},
  %{code: "Z2", description: "Bank account error"},
  %{code: "61", description: "Exceeds Withdrawal Limit"},
  %{code: "Z0", description: "Transaction Status Unconfirmed"}
]

for transaction_response <- transaction_responses do
  if Repo.get_by(TransactionResponse, code: transaction_response.code) == nil do
    changeset = TransactionResponse.changeset(%TransactionResponse{}, transaction_response)
    Repo.insert!(changeset)
  end
end

registration_no = "DS151690003477"
student = Repo.get_by(Student, registration_no: registration_no)
fee = Repo.get_by(Fee, code: "212")
payment_method = Repo.one(from t in Term, join: ts in assoc(t, :term_set), where: t.description == ^"WebPAY" and ts.name == ^"payment_method")

academic_session = Repo.get_by(AcademicSession, active: true)
transaction_response = Repo.get_by(TransactionResponse, code: "00")


%StudentPayment{}
|> StudentPayment.changeset(%{student_id: student.id, fee_id: fee.id, amount: fee.amount, service_charge: fee.service_charge, payment_method_id: payment_method.id, successful: true, transaction_response_id: transaction_response.id, academic_session_id: academic_session.id})
|> Repo.insert()



academic_session = Repo.get_by(AcademicSession, active: true)
program = Repo.get_by(Program, name: "ND")

course_registration_setting = %{academic_session_id: academic_session.id, program_id: program.id, opening_date: "2016-07-13", closing_date: "2016-08-13"}
if Repo.get_by(CourseRegistrationSetting, [academic_session_id: academic_session.id, program_id: program.id]) == nil do
  changeset = CourseRegistrationSetting.changeset(%CourseRegistrationSetting{}, course_registration_setting)
  if changeset.valid? do
    Repo.insert!(changeset)
  end
end

news = [
  %{heading: "Admission into 2016/2017 academic session has begun", lead: "Admission into 2016/2017 academic session has begun.", release_at: "2017-07-23", duration: 5, body: "Admission into 2016/2017 academic session is currently going on. Those who applied to study a course in our prestigious learning centre are to go online to apply as soon as possible. Successful applicants will be invited for screening"},
  %{heading: "Excursion", lead: "HND II mechanical engineering students will be embarking on a trip to Dubai for a tour ...", release_at: "2017-07-23", duration: 10, body: "In a bid to enhance the quality of education students of this polytechnic, the management of the Mechanical engineering department has organized a tour to Dubai car manufacturing company"}
]

Enum.each(news, fn n ->
  changeset = Newsroom.changeset(%Newsroom{}, n)
  if changeset.valid?, do: Repo.insert!(changeset)
end)

academic_session_id = AcademicSession
|> Ecto.Query.select([ac], ac.id)
|> Repo.get_by(description: "2017/2018")

program_id = Program
|> Ecto.Query.select([p], p.id)
|> Repo.get_by(name: "ND")

%ProgramAdvert{}
|> ProgramAdvert.changeset(%{academic_session_id: academic_session_id, program_id: program_id, closing_date: "2016-07-25", opening_date: "2016-07-20", active: true })
|> Repo.insert()



%JobPosting{}
|> JobPosting.changeset(%{opening_date: "2016-05-21", closing_date: "2016-08-21", active: true, application_method: "<p>Interested applicants should forward their applications together with fifteen (15) copies of detailed curriculum vitae stating among others, qualification, work experience, present employment, rank, Local Government of origin, extracurricular activities and names of three (3) referees.</p><p>All applications, which should be in sealed envelopes labeled <b>APPLICATION FOR THE POST OF WALDEN POLYTECHNIC, ABUJA</b>, are to be forwarded to:</p><p><b>The Registrar,<br>
Walden Polytechnic,<br>
Main Campus, Wuntin Dada,<br>
P.M.B. 094, Abuja,<br>
Bauchi State.</b></p>", posted_by_user_id: 3})
|> Repo.insert()

academic_session = AcademicSession |> where([a], a.description == ^"2016/2017") |> Repo.one
level = Level |> where([l], l.description == ^"ND I") |> Repo.one
semester = Term |> join(:inner, [t], ts in assoc(t, :term_set)) |> where([t, ts], t.description == ^"1st" and ts.name == ^"semester") |> Repo.one
department = Department |> where([d], d.name == ^"Mechanical Engineering") |> Repo.all |> List.first
courses = Course |> where([c], c.department_id == ^department.id and c.level_id == ^level.id and c.semester_id == ^semester.id) |> Repo.all
staff_postings = StaffPosting |> where([sp], sp.department_id == ^department.id and sp.active == ^true) |> Repo.all

Enum.each(courses, fn course ->
  %CourseTutor{}
  |> CourseTutor.changeset(%{course_id: course.id, academic_session_id: academic_session.id, staff_id: Enum.random(staff_postings).staff_id})
  |> Repo.insert()
end)

student = Student |> where([s], s.registration_no == ^"DS151690003477") |> Repo.one
student_courses = student |> Ecto.assoc(:student_courses) |> join(:inner, [sc], c in assoc(sc, :course)) |> where([sc,c], c.semester_id == ^semester.id and sc.level_id == ^level.id and sc.academic_session_id == ^academic_session.id) |> Repo.all |> Repo.preload([:course])
staff = Repo.get_by(Staff, [user_id: staff_1_user.id])
Enum.each(student_courses, fn student_course ->
    scores = [13,12,7,15,14,9,8,11]
    # score = 6 * (scores |> Enum.at(Stream.repeatedly(fn -> trunc(:random.uniform * Enum.count(scores)) end) |> Enum.take(1) |> Enum.join |> String.to_integer ))
    # score = 6 * Enum.random(scores)
    # grade = Grade |> where([g], g.minimum <= ^score and g.maximum >= ^score) |> Repo.one
    #
    # %StudentCourseGrading{}
    # |> StudentCourseGrading.changeset(%{student_course_id: student_course.id, exam: score, ca: 0, total: score, letter: grade.description, weight: grade.point, grade_point: grade.point * student_course.course.units, grade_id: grade.id, uploaded_by_staff_id: staff.id})
    # |> Repo.insert!()


    assessment_type = Term |> Ecto.Query.join(:inner, [t], ts in assoc(t, :term_set)) |> where([t, ts], t.description == "Assignment" and ts.name=="assessment_type") |> Repo.one
    %StudentCourseAssessment{}
    |> StudentCourseAssessment.changeset(%{student_course_id: student_course.id, staff_id: staff.id, assessment_type_id: assessment_type.id, score: Enum.random(scores)})
    |> Repo.insert!()

  end)
  leave_track_type = Term |> Ecto.Query.join(:inner, [t], ts in assoc(t, :term_set)) |> where([t, ts], t.description == "Days" and ts.name=="leave_track_type") |> Repo.one




[
  %{minimum_grade_level: 1, maximum_grade_level: 5, duration: 15, leave_track_type_id: leave_track_type.id},
  %{minimum_grade_level: 6, maximum_grade_level: 15, duration: 30, leave_track_type_id: leave_track_type.id}
]
|> Enum.each(fn leave_duration -> %LeaveDuration{}
                                  |> LeaveDuration.changeset(leave_duration)
                                  |> Repo.insert!() end
)

staff = Repo.get_by(Staff, [registration_no: "WLD/STF/000300"])
staff_2 = Repo.get_by(Staff, [registration_no: "WLD/STF/000302"])

leave_types = Term |> Ecto.Query.join(:inner, [t], ts in assoc(t, :term_set)) |> where([_, ts], ts.name=="leave_type") |> Repo.all


[
%{staff_id: staff.id, leave_type_id: Enum.random(leave_types).id, proposed_start_date: "2016-10-01", proposed_end_date: "2016-10-10", approved_start_date: "2016-10-01", approved_end_date: "2016-10-10", approved: true, closed: true, closed_by_staff_id: staff_2.id, closed_at: DateTime.utc_now},
%{staff_id: staff.id, leave_type_id: Enum.random(leave_types).id, proposed_start_date: "2016-10-01", proposed_end_date: "2016-10-10", approved_start_date: "2016-10-01", approved_end_date: "2016-10-10", approved: false, closed: true, closed_by_staff_id: staff_2.id, closed_at: DateTime.utc_now}
]
|> Enum.each(&(%StaffLeaveRequest{} |> StaffLeaveRequest.changeset(&1) |> Repo.insert!()))
