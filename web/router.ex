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
      resources "grades", GradeController, except: [:new, :edit]
      resources "states", StateController, except: [:new, :edit]
      resources "local_government_areas", LocalGovernmentAreaController, except: [:new, :edit]
      resources "programs", ProgramController, except: [:new, :edit]
      resources "levels", LevelController, except: [:new, :edit]
      resources "faculties", FacultyController, except: [:new, :edit]
      resources "departments", DepartmentController, except: [:new, :edit]
      resources "program_departments", ProgramDepartmentController, except: [:new, :edit]

      resources "courses", CourseController, except: [:new, :edit]

    end
  end
end
