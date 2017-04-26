defmodule Healthlocker.Router do
  use Healthlocker.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Healthlocker.Plugs.Auth, repo: Healthlocker.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # endpoints requiring a logged in user
  scope "/", Healthlocker do
    pipe_through [:browser, Healthlocker.Plugs.RequireLogin]

    resources "/posts", PostController, only: [:new, :create] do
      post "/likes", PostController, :likes
    end

    resources "/coping-strategy", CopingStrategyController
    resources "/goal", GoalController
    put "/goal/:id/important", GoalController, :mark_important
    resources "/toolkit", ToolkitController, only: [:index]
    resources "/account", AccountController, only: [:index]
    put "/account/update", AccountController, :update
    get "/account/consent", AccountController, :consent
    put "/account/consent/update", AccountController, :update_consent
    get "/account/security/edit", AccountController, :edit_security
    put "/account/security/update", AccountController, :update_security
    get "/account/password/edit", AccountController, :edit_password
    put "/account/password/update", AccountController, :update_password
    get "/account/slam", AccountController, :slam
    put "/account/check-slam", AccountController, :check_slam
    resources "/components", ComponentController, only: [:index]
    resources "/messages", MessageController, only: [:index]
    resources "/sleep-tracker", SleepTrackerController, only: [:index, :new, :create] do
      get "/prev-date", SleepTrackerController, :prev_date
      get "/next-date", SleepTrackerController, :next_date
    end
    resources "/care-plan", CarePlanController, only: [:index]
    resources "/caseload", CaseloadController, only: [:index]
  end

  # endpoints not requiring a logged in user
  scope "/", Healthlocker do
    pipe_through :browser

    get "/", PageController, :index
    resources "/feedback", FeedbackController, only: [:index, :create]
    resources "/login", LoginController, only: [:index, :create, :delete]
    resources "/users", UserController, only: [:index, :new, :create, :update] do
      get "/signup2", UserController, :signup2
      put "/create2", UserController, :create2
      get "/signup3", UserController, :signup3
      put "/create3", UserController, :create3
    end
    resources "/pages", PageController, only: [:index, :show]
    resources "/posts", PostController, only: [:show, :index]
    resources "/support", SupportController, only: [:index]
    resources "/tips", TipController, only: [:index]
  end
end
