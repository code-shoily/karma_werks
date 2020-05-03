defmodule KarmaWerks.Auth.User do
  @moduledoc false

  alias KarmaWerks.Helpers.Validators

  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :email, :string
    field :password, :string
    field :password_confirmation, :string, virtual: true
    field :token, :string
  end

  @fields ~w/name email password password_confirmation/a
  def signup_changeset(user, params \\ %{}) do
    user
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_length(:password, min: 6)
    |> validate_password_confirmation()
    |> Validators.validate_email(:email)
  end

  @fields ~w/email password/a
  def signin_changeset(user, params \\ %{}) do
    user
    |> cast(params, @fields)
    |> validate_required(@fields)
  end

  @fields ~w/token/a
  def token_changeset(user, params \\ %{}) do
    user
    |> cast(params, @fields)
    |> validate_required(@fields)
  end

  @fields ~w/email/a
  def password_reset_changeset(user, params \\ %{}) do
    user
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> Validators.validate_email(:email)
  end

  defp validate_password_confirmation(%{changes: changes} = changeset) do
    if changes[:password] == changes[:password_confirmation] do
      changeset
    else
      changeset
      |> add_error(:password, "Passwords don't match")
      |> add_error(:password_confirmation, "Passwords don't match")
    end
  end
end
