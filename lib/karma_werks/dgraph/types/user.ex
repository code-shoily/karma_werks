defmodule KarmaWerks.Dgraph.Types.User do
  alias KarmaWerks.Dgraph

  @stmt """
  name: string @index(term) .
  email: string @index(exact) @upsert .
  password: password .

  type User {
    name
    email
    password
  }
  """
  def create, do: Dgraph.alter(@stmt)
end
