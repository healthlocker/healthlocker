defmodule Healthlocker.Step do
  use Healthlocker.Web, :model

  schema "steps" do
    field :details, :string
    field :complete, :boolean
    belongs_to :user, Healthlocker.User

    timestamps()
  end
end
