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

      scope "/interswitch", Interswitch, as: :interswitch do
          post "/webpay", WebPayController, :create
          post "/customer", CustomerController, :show
          post "/payment", PaymentController, :create 
      end

      resources "/roles", RoleController, except: [:new, :edit]
      resources "/users", UserController, except: [:new, :edit]
      resources "/user_profiles", UserProfileController, except: [:new, :edit]
      resources "/user_roles", UserRoleController, except: [:new, :edit]      
      post "/sessions", SessionController, :create
      delete "/sessions", SessionController, :delete
      get "/current_user", CurrentUserController, :show
      resources "/term_sets", TermSetController, except: [:new, :edit]
      resources "/terms", TermController, except: [:new, :edit]      
      resources "/states", StateController, except: [:new, :edit]
      resources "/local_government_areas", LocalGovernmentAreaController, except: [:new, :edit]
      resources "/jamb_records", JambRecordController, except: [:new, :edit]
      resources "/diploma_qualifications", DiplomaQualificationController, except: [:new, :edit]
      resources "/direct_entry_qualifications", DirectEntryQualificationController, except: [:new, :edit]
      resources "/certificates", CertificateController, except: [:new, :edit]
      resources "/certificate_items", CertificateItemController, except: [:new, :edit]
      resources "/announcements", AnnouncementController, except: [:new, :edit]
      resources "/academic_qualifications", AcademicQualificationController, except: [:new, :edit]
      resources "/program_applications", ProgramApplicationController, except: [:new, :edit]
      resources "/salary_grade_levels", SalaryGradeLevelController, except: [:new, :edit]
      resources "/salary_grade_steps", SalaryGradeStepController, except: [:new, :edit]      
      # Faculty Module
      resources "/programs", ProgramController, except: [:new, :edit]
      resources "/program_adverts", ProgramAdvertController, except: [:new, :edit]
      resources "/levels", LevelController, except: [:new, :edit]
      resources "/faculties", FacultyController, except: [:new, :edit]
      resources "/faculty_heads", FacultyHeadController, except: [:new, :edit]
      resources "/departments", DepartmentController, except: [:new, :edit]
      resources "/department_heads", DepartmentHeadController, except: [:new, :edit]
      resources "/program_departments", ProgramDepartmentController, except: [:new, :edit]
      resources "/academic_sessions", AcademicSessionController, except: [:new, :edit]
      resources "/assignments", AssignmentController, except: [:new, :edit]      
      resources "/jobs", JobController, except: [:new, :edit]
      resources "/job_postings", JobPostingController, except: [:new, :edit]
      resources "/job_titles", JobTitleController, except: [:new, :edit]            
      resources "/postings", PostingController, except: [:new, :edit]      
      resources "/leave_durations", LeaveDurationController, except: [:new, :edit]      
      resources "/leave_requests", LeaveRequestController, except: [:new, :edit]      
      resources "/grades", GradeController, except: [:new, :edit]
      resources "/grade_change_requests", GradeChangeRequestController, except: [:new, :edit]
      resources "/courses", CourseController, except: [:new, :edit]
      resources "/course_tutors", CourseTutorController, except: [:new, :edit]            
      resources "/fees", FeeController, except: [:new, :edit]
      resources "/payments", PaymentController, except: [:new, :edit]
      resources "/payment_items", PaymentItemController, except: [:new, :edit]
      resources "/service_charges", ServiceChargeController, except: [:new, :edit]
      resources "/service_charge_splits", ServiceChargeSplitController, except: [:new, :edit]      
      resources "/course_registration_settings", CourseRegistrationSettingController, except: [:new, :edit]
      resources "/course_enrollments", CourseEnrollmentController, except: [:new, :edit]
      resources "/course_enrollment_assessments", CourseEnrollmentAssessmentController, except: [:new, :edit]
      resources "/course_gradings", CourseGradingController, except: [:new, :edit]

      resources "/project_topics", ProjectTopicController, except: [:new, :edit]
      resources "/student_project_supervisors", StudentProjectSupervisorController, except: [:new, :edit]
      
      resources "/results", ResultController, except: [:new, :edit]
      resources "/result_grades", ResultGradeController, except: [:new, :edit]
      resources "/student_assignments", StudentAssignmentController, except: [:new, :edit]



      resources "/products", ProductController, except: [:new, :edit]
      resources "/orders", OrderController, except: [:new, :edit]


    end
  end
end
