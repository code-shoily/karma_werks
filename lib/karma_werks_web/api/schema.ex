defmodule KarmaWerksWeb.Api.Schema do
  use Absinthe.Schema

  import_types KarmaWerksWeb.Api.Types.AuthTypes

  alias KarmaWerksWeb.Api.Resolvers.AuthResolvers

  query do
    @desc "Finder users by email"
    field :find_user_by_email, :user do
      arg :email, :string
      resolve &AuthResolvers.find_user/3
    end
  end

  mutation do
    field :register_user, :user do
      arg :input, :registration_input
      resolve &AuthResolvers.register_user/3
    end
  end
end
