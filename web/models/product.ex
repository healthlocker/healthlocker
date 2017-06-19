defmodule Healthlocker.Product do
  use Healthlocker.Web, :model

  @primary_key {:ProductId, :integer, autogenerate: false}
  schema "Products" do
    field :ProductName, :string
  end
end
