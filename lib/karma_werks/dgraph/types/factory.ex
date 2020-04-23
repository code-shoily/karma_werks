defmodule KarmaWerks.Dgraph.Types.Factory do
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
