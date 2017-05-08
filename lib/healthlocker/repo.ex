defmodule Healthlocker.Repo do
  use Ecto.Repo, otp_app: :healthlocker
  use Scrivener, page_size: 10
end
