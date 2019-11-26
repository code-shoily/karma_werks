defmodule KarmaWerksWeb.Api.Resolvers.AuthResolvers do
  alias KarmaWerks.Auth.Services

  def find_user(_parent, %{email: email}, _context) do
    email
    |> Services.get_user_by_email()
    |> AtomicMap.convert()
    |> case do
      nil -> {:error, "User doesn't exist"}
      user -> {:ok, user}
    end
  end

  def register_user(_parent, %{input: args}, _context) do
    case Services.register_user(args) do
      {:ok, result} ->
        {:ok,
         Services.get_user_by_uid(
           result
           |> Map.to_list()
           |> hd()
           |> elem(1)
         )}

      {:error, _} = error ->
        error
    end
  end
end
