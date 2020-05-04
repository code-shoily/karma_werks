defmodule KarmaWerks.Auth do
  alias __MODULE__.{User, Operations}
  alias Ecto.Changeset

  require Logger

  @spec signup(map()) :: {:ok, map()} | {:error, Changeset.t()}
  def signup(params) do
    changeset = User.signup_changeset(%User{}, params)

    with %{valid?: true, changes: changes} <- changeset,
         signup_data <- Map.delete(changes, :password_confirmation),
         {:ok, _} = data <- Operations.create_user(signup_data) do
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
         {true, uid} <- Operations.authenticate(email, password) do
      {:ok, uid}
    else
      {false, _} -> {:error, changeset |> Changeset.add_error(:base, "Invalid credentials")}
      _ -> {:error, changeset}
    end
  end
end
