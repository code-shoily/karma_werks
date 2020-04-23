defmodule KarmaWerks.Auth do
  alias KarmaWerks.Dgraph

  @type registration_input :: %{
          first_name: String.t(),
          last_name: String.t(),
          email: String.t(),
          password: String.t()
        }

  @spec register_user(registration_input) :: {:ok, map()} | {:error, any()}
  def register_user(
        %{"first_name" => _, "last_name" => _, "email" => email, "password" => _} = payload
      ) do
    with {:email, nil} <- {:email, get_user_by_email(email)} do
      payload
      |> Map.merge(%{"<dgraph.type>" => "User"})
      |> Dgraph.mutate()
    else
      {:email, _} -> {:error, "User with email #{email} already exists"}
      _ -> {:error, "Error in registration"}
    end
  end

  @doc """
  Fetches user(s) with matching criteria.
  """
  @spec get_user_by(String.t(), String.t()) :: {:ok, [map()]} | {:error, any}
  def get_user_by(attribute, value) do
    query = ~s/{
      result (func: eq(#{attribute}, "#{value}")) {
        uid
        first_name
        last_name
        email
      }
    }/ |> String.replace("\n", "")

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
    case get_user_by("email", email) do
      {:ok, [result]} -> result
      _ -> nil
    end
  end

  @doc """
  Deletes the user with matching `uid`.
  """
  @spec delete_user(String.t()) :: {:ok, map()} | {:error, any()}
  def delete_user(uid) do
    Dgraph.delete(%{uid: uid})
  end


  @doc """
  Fetches the user with matching `uid`. Returns `nil` if user not found.
  """
  @spec get_user_by_uid(String.t()) :: map() | nil
  def get_user_by_uid(uid) do
    query = ~s/{
      result (func: uid(#{uid})) {
        uid
        first_name
        last_name
        email
      }
    }/

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
  @spec authenticate(String.t(), String.t()) :: bool
  def authenticate(email, password) do
    ~s[{
      result (func: eq(email, "#{email}")) {
        checkpwd(password, "#{password}")
      }
    }]
    |> Dgraph.query()
    |> case do
      {:ok, %{"result" => [%{"checkpwd(password)" => result}]}} -> result
      _ -> false
    end
  end

  @doc """
  Changes password of the user given old and new password and email. It will attempt to change
  password only if the old password manages to succeed for email given.
  """
  @spec change_password(String.t(), String.t(), String.t()) :: {:ok, map()} | {:error, any}
  def change_password(email, old_password, password) do
    if authenticate(email, old_password) do
      case get_user_by_email(email) do
        %{"uid" => uid} -> update_user(uid, %{password: password})
        _ -> {:error, "Error"}
      end
    else
      {:error, "Wrong password provided"}
    end
  end
end
