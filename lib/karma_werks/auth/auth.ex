defmodule KarmaWerks.Auth do
  alias __MODULE__.Operations
  alias Ecto.Changeset

  @spec signup(Changeset.t()) :: {:ok, map()} | {:error, Changeset.t()}
  def signup(%Changeset{changes: changes, valid?: true} = changeset) do
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

  @spec signin(Changeset.t()) :: {:ok, true} | {:error, Changeset.t()}
  def signin(%Changeset{changes: changes, valid?: true} = changeset) do
    case Operations.authenticate(changes[:email], changes[:password]) do
      true ->
        {:ok, true}

      false ->
        changeset =
          changeset
          |> Changeset.add_error(:base, "Invalid credentials")

        {:error, changeset}
    end
  end

  def signin(changeset), do: {:error, changeset}
end
