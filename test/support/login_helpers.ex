defmodule Healthlocker.LoginHelpers do
  use Wallaby.DSL

  @login_form     Query.css("form")
  @email_field    Query.text_field("Email address")
  @password_field Query.text_field("Password")
  @login_button   Query.button("Log in")

  def log_in(session, email \\ "tony@dwyl.io", password \\ "password") do
    page = session |> visit("/login")

    find(page, @login_form, fn(form) ->
      form
      |> fill_in(@email_field, with: email)
      |> fill_in(@password_field, with: password)
      |> click(@login_button)
    end)
  end
end
