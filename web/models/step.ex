defmodule Healthlocker.Step do

  @moduledoc """
  Defines steps schema and defines methods for interacting with it 
  """

  use Healthlocker.Web, :model

  schema "steps" do
    field :details, :string
    field :complete, :boolean
    belongs_to :goal, Healthlocker.Goal

    timestamps()
  end

  def changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:details, :complete])
  end
end
