defmodule KarmaWerks.Auth do
  alias __MODULE__.{User, Operations}
  alias Ecto.Changeset

  require Logger

  @spec signup(Changeset.t()) :: {:ok, map()} | {:error, Changeset.t()}
  def signup(%Changeset{changes: changes, valid?: true} = changeset) do
    changes = Map.delete(changes, :password_confirmation)
    case Operations.create_user(changes) do
      {:ok, _} = data ->
        data

      {:error, :email_exists} ->
        changeset
        |> Changeset.add_error(:email, "This email already exists")
        |> Changeset.apply_action(:insert)

      {:error, _} ->
        {:error, changeset}
    end
  end

  def signup(changeset), do: {:error, changeset}

  @spec reset(map()) :: {:ok, map()} | {:error, Changeset.t()}
  def reset(params) do
    Logger.warn("Password reset has not been implemented yet")
    case User.password_reset_changeset(%User{}, params) do
      %{valid?: true} -> {:ok, %{}}
      changeset -> {:error, changeset}
    end
  end

  @spec signin(Changeset.t()) :: {:ok, binary()} | {:error, Changeset.t()}
  def signin(%Changeset{changes: changes, valid?: true} = changeset) do
    case Operations.authenticate(changes[:email], changes[:password]) do
      {true, uid} ->
        {:ok, uid}

      _ ->
        changeset =
          changeset
          |> Changeset.add_error(:base, "Invalid credentials")

        {:error, changeset}
    end
  end

  def signin(changeset), do: {:error, changeset}
end
