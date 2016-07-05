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
  end

  scope "/", PortalApi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", PortalApi do
    pipe_through :api
    scope "/v1", V1, as: :v1 do

      resources "term_sets", TermSetController, except: [:new, :edit]
      resources "terms", TermController, except: [:new, :edit]
      resources "states", StateController, except: [:new, :edit]
      resources "local_government_areas", LocalGovernmentAreaController, except: [:new, :edit]

      # Faculty Module
      resources "programs", ProgramController, except: [:new, :edit]
      resources "levels", LevelController, except: [:new, :edit]
      resources "faculties", FacultyController, except: [:new, :edit]
      resources "departments", DepartmentController, except: [:new, :edit]
      resources "program_departments", ProgramDepartmentController, except: [:new, :edit]
      resources "assignments", AssignmentController, except: [:new, :edit]

      # Human Resources Module
      resources "job_titles", JobTitleController, except: [:new, :edit]
      resources "staffs", StaffController, except: [:new, :edit]
      resources "staff_postings", StaffPostingController, except: [:new, :edit]

      # Courses Module
      resources "grades", GradeController, except: [:new, :edit]
      resources "courses", CourseController, except: [:new, :edit]

      # Accounts/Bursary
      resources "salary_grade_levels", SalaryGradeLevelController, except: [:new, :edit]
      resources "salary_grade_steps", SalaryGradeStepController, except: [:new, :edit]
      resources "fees", FeeController, except: [:new, :edit]
      resources "payments", PaymentController, except: [:new, :edit]
      resources "payment_items", PaymentItemController, except: [:new, :edit]

      # Student Module
      resources "students", StudentController, except: [:new, :edit]
      resources "course_enrollments", CourseEnrollmentController, except: [:new, :edit]
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
