defmodule KarmaWerksWeb.Api.Types.AuthTypes do
  use Absinthe.Schema.Notation

  @desc "A user of the system"
  object :user do
    field :uid, :id
    field :name, :string
    field :email, :string
    field :bio, :string
  end

  @desc "Registration input"
  input_object :registration_input do
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :password, non_null(:string)
    field :bio, :string
  end
end
