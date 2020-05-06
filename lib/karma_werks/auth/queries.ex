defmodule KarmaWerks.Auth.Queries do
  @moduledoc """
  Contains all queries relevant to auth context.
  """

  alias KarmaWerks.Dgraph

  @type uid :: binary()

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
end
