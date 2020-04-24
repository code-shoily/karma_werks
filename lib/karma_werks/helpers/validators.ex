defmodule KarmaWerks.Helpers.Validators do
  @moduledoc false

  alias Ecto.Changeset

  @email_regex ~r/^[A-Za-z0-9\._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$/
  def validate_email(email) when is_binary(email) do
    Regex.match?(@email_regex, email)
  end

  def validate_email(%Changeset{changes: changes} = changeset, field) do
    if validate_email(changes[field]) do
      changeset
    else
      Changeset.add_error(changeset, field, "invalid email")
    end
  end
end
