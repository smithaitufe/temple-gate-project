defmodule PortalApi.Router do
  use PortalApi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/", PortalApi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", PortalApi do
    pipe_through :api

    scope "/v1", V1, as: :v1 do

      resources "users", UserController, except: [:new, :edit]
      resources "user_roles", UserRoleController, except: [:new, :edit]
      resources "sessions", SessionController, only: [:create, :delete]
      get "current_user", CurrentUserController, :show
      resources "term_sets", TermSetController, except: [:new, :edit]
      resources "terms", TermController, except: [:new, :edit]
      get "term_sets/:name/terms", TermController, :get_terms_by_term_set_name


      resources "states", StateController, except: [:new, :edit]
      resources "local_government_areas", LocalGovernmentAreaController, except: [:new, :edit]

      # Faculty Module
      resources "programs", ProgramController, except: [:new, :edit]
      resources "levels", LevelController, except: [:new, :edit]
      resources "faculties", FacultyController, except: [:new, :edit]
      resources "departments", DepartmentController, except: [:new, :edit]

      resources "program_departments", ProgramDepartmentController, except: [:new, :edit]
      resources "academic_sessions", AcademicSessionController, except: [:new, :edit]
      resources "assignments", AssignmentController, except: [:new, :edit]


      # Human Resources Module
      resources "job_titles", JobTitleController, except: [:new, :edit]
      resources "staffs", StaffController, except: [:new, :edit]
      resources "staff_postings", StaffPostingController, except: [:new, :edit]
      resources "staff_academic_qualifications", StaffAcademicQualificationController, except: [:new, :edit]

      # Courses Module
      resources "grades", GradeController, except: [:new, :edit]
      resources "courses", CourseController, except: [:new, :edit]
      get "departments/:department_id/levels/:level_id/courses", CourseController, :get_courses_by_department_and_level



      get "students/:student_id/levels/:level_id/courses", CourseController, :get_courses_by_student_and_level

      # Accounts/Bursary
      resources "salary_grade_levels", SalaryGradeLevelController, except: [:new, :edit]
      resources "salary_grade_steps", SalaryGradeStepController, except: [:new, :edit]
      resources "fees", FeeController, except: [:new, :edit]
      resources "payments", PaymentController, except: [:new, :edit]
      resources "payment_items", PaymentItemController, except: [:new, :edit]

      # Student Module
      resources "students", StudentController, except: [:new, :edit]
      get "students/:user_id/record", StudentController, :get_student_by_user_id

      resources "course_enrollments", CourseEnrollmentController, except: [:new, :edit]
      get "students/:student_id/level/:level_id/courses", CourseEnrollmentController, :get_student_course_enrollment_by_level

      resources "project_topics", ProjectTopicController, except: [:new, :edit]
      resources "student_project_supervisors", StudentProjectSupervisorController, except: [:new, :edit]
      resources "student_continuous_assessments", StudentContinuousAssessmentController, except: [:new, :edit]
      resources "student_results", StudentResultController, except: [:new, :edit]
      resources "student_result_grades", StudentResultGradeController, except: [:new, :edit]
      resources "student_assignments", StudentAssignmentController, except: [:new, :edit]
      resources "student_payments", StudentPaymentController, except: [:new, :edit]

    end
  end
end
