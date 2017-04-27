defmodule Healthlocker.Carer do
  use Healthlocker.Web, :model

  @primary_key false
  schema "carers" do
    belongs_to :carer, Healthlocker.User
    belongs_to :caring, Healthlocker.User
  end
end
