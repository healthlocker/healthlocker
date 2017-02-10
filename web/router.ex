defmodule Healthlocker.Router do
  use Healthlocker.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Healthlocker.Auth, repo: Healthlocker.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Healthlocker do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/posts", PostController, only: [:show, :new, :create, :index]
    resources "/tips", TipController, only: [:index]
    get "/support", SupportController, :index
    resources "/users", UserController, only: [:index, :new, :create, :update]
    get "/users/:id/signup2", UserController, :signup2
    post "/users/:id/create2", UserController, :create2
    get "/users/:id/signup3", UserController, :signup3
    post "/users/:id/create3", UserController, :create3
    resources "/login", LoginController, only: [:index, :create, :delete]

  end

  # Other scopes may use custom stacks.
  # scope "/api", Healthlocker do
  #   pipe_through :api
  # end
end
