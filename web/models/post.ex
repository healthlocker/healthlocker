defmodule Healthlocker.Post do
  use Healthlocker.Web, :model

  schema "posts" do
    field :content, :string

    timestamps
  end
end
