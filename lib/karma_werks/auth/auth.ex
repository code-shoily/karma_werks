defmodule KarmaWerks.Auth do
  @moduledoc """
  Authentication context for KarmaWerks
  """
  alias __MODULE__.{Mutations, Queries, User}
  alias Ecto.Changeset

  require Logger

  defdelegate authenticate(email, password), to: Queries
  defdelegate get_user_by_uid(uid), to: Queries

  @spec signup(map()) :: {:ok, map()} | {:error, Changeset.t()}
  def signup(params) do
    changeset = User.signup_changeset(%User{}, params)

    with %{valid?: true, changes: changes} <- changeset,
         signup_data <- Map.delete(changes, :password_confirmation),
         {:ok, _} = data <- Mutations.create_user(signup_data) do
      data
    else
      {:error, :email_exists} ->
        {:error,
         changeset
         |> Changeset.add_error(:email, "This email already exists")}

      _ ->
        {:error, changeset}
    end
  end

  @spec reset(map()) :: {:ok, map()} | {:error, Changeset.t()}
  def reset(params) do
    Logger.warn("Password reset has not been implemented yet")

    case User.password_reset_changeset(%User{}, params) do
      %{valid?: true} -> {:ok, %{}}
      changeset -> {:error, changeset}
    end
  end

  @spec signin(map()) :: {:ok, binary()} | {:error, Changeset.t()}
  def signin(params) do
    changeset = User.signin_changeset(%User{}, params)

    with %{valid?: true, changes: changes} <- changeset,
         %{email: email, password: password} <- changes,
         {true, uid} <- authenticate(email, password) do
      {:ok, uid}
    else
      {false, _} -> {:error, changeset |> Changeset.add_error(:base, "Invalid credentials")}
      _ -> {:error, changeset}
    end
  end
end
