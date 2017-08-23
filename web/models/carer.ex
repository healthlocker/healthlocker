defmodule Healthlocker.Carer do
  use Healthlocker.Web, :model

  @primary_key false
  schema "carers" do
    belongs_to :carer, Healthlocker.User
    belongs_to :caring, Healthlocker.User
    field :slam_id, :integer
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:carer_id, :caring_id, :slam_id])
    |> validate_required([:carer_id, :slam_id])
    |> unique_constraint(:carer_id, name: :carers_carer_id_slam_id_index)
  end
end
