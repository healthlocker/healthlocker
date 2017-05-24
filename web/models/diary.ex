defmodule Healthlocker.Diary do
  use Healthlocker.Web, :model

  schema "diaries" do
    field :entry, :string, null: false
    belongs_to :user, Healthlocker.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:entry])
    |> validate_required([:entry])
  end
end
