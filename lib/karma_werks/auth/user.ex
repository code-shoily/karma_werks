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
  end

  @fields ~w/name email password password_confirmation/a
  def registration_changeset(user, params) do
    user
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_length(:password, min: 6)
    |> validate_password_confirmation()
    |> Validators.validate_email(:email)
  end

  defp validate_password_confirmation(%{changes: changes} = changeset) do
    if changes.password == changes.password_confirmation do
      changeset
    else
      add_error(changeset, :password_confirmation, "must match password")
    end
  end
end
