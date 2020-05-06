defmodule KarmaWerks.Auth.Operations do
  @moduledoc """
  Modules for all Dgraph operations for authentication context
  """

  alias KarmaWerks.Dgraph

  @type uid :: binary()
  @type user_create_input :: %{
          name: String.t(),
          email: String.t(),
          password: String.t()
        }

  @spec create_user(user_create_input) :: {:ok, map()} | {:error, any()}
  def create_user(%{name: _, email: email, password: _} = payload) do
    case get_user_by_email(email) do
      nil ->
        payload
        |> Map.merge(%{"<dgraph.type>" => "User"})
        |> Dgraph.mutate()

      _ -> {:error, :email_exists}
    end
  end

  @doc """
  Fetches user(s) with matching criteria.
  """
  @spec get_users_by(String.t(), String.t()) :: {:ok, [map()]} | {:error, any}
  def get_users_by(attribute, value) do
    query = ~s[{
      result (func: eq(#{attribute}, "#{value}")) {
        uid
        name
        email
      }
    }]

    case Dgraph.query(query) do
      {:ok, %{"result" => result}} -> {:ok, result}
      error -> error
    end
  end

  @doc """
  Returns the user with matching `email`, `nil` otherwise.
  """
  @spec get_user_by_email(String.t()) :: nil | map()
  def get_user_by_email(email) do
    case get_users_by("email", email) do
      {:ok, [result]} -> result
      _ -> nil
    end
  end

  @doc """
  Fetches the user with matching `uid`. Returns `nil` if user not found.
  """
  @spec get_user_by_uid(String.t()) :: map() | nil
  def get_user_by_uid(uid) do
    query = ~s[{
      result (func: uid(#{uid})) {
        uid
        name
        email
      }
    }]

    case Dgraph.query(query) do
      {:ok, %{"result" => [node]}} when map_size(node) > 1 -> node
      _ -> nil
    end
  end

  @doc """
  Updates user matching `uid` based on data given in `params`.
  """
  @spec update_user(String.t(), map()) :: {:ok, map()} | {:error, any}
  def update_user(uid, fields) do
    uid
    |> get_user_by_uid()
    |> Map.merge(fields)
    |> Dgraph.mutate()
  end

  @doc """
  Tests if the password succeeds for user with email `email`.
  """
  @spec authenticate(String.t(), String.t()) :: {bool, nil | uid()}
  def authenticate(email, password) do
    ~s[{
      result (func: eq(email, "#{email}")) {
        uid
        checkpwd(password, "#{password}")
      }
    }]
    |> Dgraph.query()
    |> case do
      {:ok, %{"result" => [%{"checkpwd(password)" => true, "uid" => uid}]}} -> {true, uid}
      _ -> {false, nil}
    end
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
