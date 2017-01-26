defmodule Healthlocker.Router do
  use Healthlocker.Web, :router

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

  scope "/", Healthlocker do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/posts", PostController, only: [:show, :new, :create]
    resources "/users", UserController, only: [:show, :new, :create, :index, :edit, :delete, :update]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Healthlocker do
  #   pipe_through :api
  # end
end
