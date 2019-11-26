defmodule KarmaWerks.Auth.Services do
  @moduledoc """
  Authentication management services
  """
  import ShorterMaps

  @type registration_input :: %{
          required(String.t()) => String.t()
        }

  @doc """
  Creates a new user.

  TODO: Use upsert for testing for uniqueness
  """
  @spec register_user(registration_input) :: {:ok, map()} | {:error, any()}
  def register_user(~m/name, email, bio, password/) do
    with {:email, {:ok, []}} <- {:email, get_user_by("email", email)} do
      payload = %{
        "user_name" => name,
        "user_email" => email,
        "user_bio" => bio,
        "user_password" => password,
      }
      Dlex.mutate(:karma_werks, payload)
    else
      {:email, _} -> {:error, "User with email #{email} already exists"}
      _ -> {:error, "Error in registration"}
    end
  end

  def register_user(~M/name, email, bio, password/), do:
    register_user(~m/name, email, bio, password/)

  @doc """
  Fetches the user with matching `uid`. Returns `nil` if user not found.
  """
  @spec get_user_by_uid(String.t()) :: map() | nil
  def get_user_by_uid(uid) do
    query = ~s/{
      result (func: uid(#{uid})) {
        uid
        name : user_name
        email : user_email
        bio : user_bio
        password : user_password
      }
    }/ |> String.replace("\n", "")

    case Dlex.query(:karma_werks, query) do
      {:ok, %{"result" => [node]}} when map_size(node) > 1 -> node
      _ -> nil
    end
  end

  @doc """
  Fetches user(s) with matching criteria.
  """
  @spec get_user_by(String.t(), String.t()) :: {:ok, [map()]} | {:error, any}
  def get_user_by(attribute, value) do
    query = ~s/{
      result (func: eq(user_#{attribute}, "#{value}")) {
        uid
        name : user_name
        email : user_email
        bio : user_bio
        password : user_password
      }
    }/ |> String.replace("\n", "")

    case Dlex.query(:karma_werks, query) do
      {:ok, %{"result" => result}} -> {:ok, result}
      error -> error
    end
  end

  @doc """
  Returns the user with matching `email`, `nil` otherwise.
  """
  @spec get_user_by_email(String.t()) :: nil | map()
  def get_user_by_email(email) do
    case get_user_by("email", email) do
      {:ok, [result]} -> result
      _ -> nil
    end
  end

  @doc """
  Deletes the user with matching `uid`.

  TODO: This function will go away
  """
  @spec delete_user(String.t()) :: {:ok, map()} | {:error, any()}
  def delete_user(uid) do
    Dlex.delete(:karma_werks, ~m/uid/)
  end

  @doc """
  Updates user matching `uid` based on data given in `params`.
  """
  @spec update_user(String.t(), map()) :: {:ok, map()} | {:error, any}
  def update_user(uid, fields) do
    uid
    |> get_user_by_uid()
    |> Map.merge(fields |> prefixed_keys("user_"))
    |> (fn d -> Dlex.mutate(:karma_werks, d) end).()
  end

  @doc """
  Tests if the password succeeds for user with email `email`.
  """
  @spec authenticate(String.t(), String.t()) :: bool
  def authenticate(email, password) do
    query = ~s/{
      result (func: eq(user_email, "#{email}")) {
        checkpwd(user_password, "#{password}")
      }
    }/ |> String.replace("\n", "")

    {:ok, %{"result" => [%{"checkpwd(user_password)" => result}]}} = Dlex.query(:karma_werks, query)

    result
  end

  @doc """
  Changes password of the user given old and new password and email. It will attempt to change
  password only if the old password manages to succeed for email given.
  """
  @spec change_password(String.t(), String.t(), String.t()) :: {:ok, map()} | {:error, any}
  def change_password(email, old_password, password) do
    if authenticate(email, old_password) do
      case get_user_by_email(email) do
        %{"uid" => uid} -> update_user(uid, ~m/password/)
        _ -> {:error, "Error"}
      end
    else
      {:error, "Wrong password provided"}
    end
  end

  def prefixed_keys(params, prefix) do
    params
    |> Map.to_list()
    |> Enum.map(fn {k, v} ->
      {prefix <> to_string(k), v}
    end)
    |> Enum.into(%{})
  end
end
