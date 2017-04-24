defmodule Healthlocker.Carer do
  use Healthlocker.Web, :model

  @primary_key false
  schema "carers" do
    belongs_to :carer, Healthlocker.User, foreign_key: :carer_id
    belongs_to :caring, Healthlocker.User, foreign_key: :caring_id
  end
end
