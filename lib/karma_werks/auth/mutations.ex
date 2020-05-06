defmodule KarmaWerks.Auth.Mutations do
  @moduledoc """
  Modules for all Dgraph operations for authentication context
  """

  alias KarmaWerks.Auth.Queries
  alias KarmaWerks.Dgraph

  @type user_create_input :: %{
          name: String.t(),
          email: String.t(),
          password: String.t()
        }

  @spec create_user(user_create_input) :: {:ok, map()} | {:error, any()}
  def create_user(%{name: _, email: email, password: _} = payload) do
    case Queries.get_user_by_email(email) do
      nil ->
        payload
        |> Map.merge(%{"<dgraph.type>" => "User"})
        |> Dgraph.mutate()

      _ -> {:error, :email_exists}
    end
  end

  @doc """
  Updates user matching `uid` based on data given in `params`.
  """
  @spec update_user(String.t(), map()) :: {:ok, map()} | {:error, any}
  def update_user(uid, fields) do
    uid
    |> Queries.get_user_by_uid()
    |> Map.merge(fields)
    |> Dgraph.mutate()
  end

  # @doc """
  # Changes password of the user given old and new password and email. It will attempt to change
  # password only if the old password manages to succeed for email given.
  # """
  # @spec change_password(String.t(), String.t(), String.t()) :: {:ok, map()} | {:error, any}
  # def change_password(email, old_password, password) do
  #   if authenticate(email, old_password) do
  #     case get_user_by_email(email) do
  #       %{"uid" => uid} -> update_user(uid, %{password: password})
  #       _ -> {:error, nil}
  #     end
  #   else
  #     {:error, :wrong_credentials}
  #   end
  # end
end
