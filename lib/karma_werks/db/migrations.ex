defmodule KarmaWerks.DB.Migrations do
  @moduledoc false

  import ShorterMaps

  @predicates ~S/
    name: string @index(term, fulltext, trigram) .
    email: string @index(exact) @upsert .
    password: password .
    phone: string @index(exact) @upsert .
    bio: string @index(fulltext, trigram) .
    joinDate: dateTime .
    slug: string @index(exact) @upsert .
    members: [uid] @reverse @count .
  /

  @types ~S/
    type User {
      name: string
      email: string
      password: password
      phone: string
      bio: string
      joinDate: dateTime
    }

    type Organization {
      name: string
      slug: string
      members: [uid]
    }
  /

  defp create_predicates do
    Dlex.alter(:karma_werks, @predicates)
  end

  defp create_types do
    Dlex.alter(:karma_werks, @types)
  end

  @spec run :: {:ok, map} | {:error, Dlex.Error.t | term}
  def run do
    with {:ok, predicates} <- create_predicates(),
         {:ok, types} <- create_types() do
      {:ok, ~M{predicates, types}}
    else
      error -> error
    end
  end
end
