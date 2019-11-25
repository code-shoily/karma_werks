defmodule KarmaWerksWeb.Api.Schema do
  use Absinthe.Schema

  query do
    @desc "Say Hello"
    field :hello, :string do
      resolve (fn _, _, _ -> {:ok, "HELLO WORLD!"} end)
    end
  end
end
