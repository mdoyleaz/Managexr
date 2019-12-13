defmodule ManagexrWeb.Schema.Accounts do
  use Absinthe.Schema.Notation

  object :user do
    field(:id, :binary_id)
    field(:email, :string)
  end
end
