defmodule KarmaWerks.Dgraph.Types.Factory do
  @moduledoc """
  Creates and migrates Dgraph types for the database.
  """
  alias KarmaWerks.Dgraph.Types.User

  @type_modules [
    User
  ]
  def create(type_modules \\ @type_modules) do
    Enum.reduce(type_modules, [], fn module, acc ->
      case apply(module, :create, []) do
        {:ok, _} -> acc
        {:error, message} -> [message | acc]
      end
    end)
    |> case do
      [] -> :ok
      errors -> {:error, errors}
    end
  end
end
