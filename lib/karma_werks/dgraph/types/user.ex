defmodule KarmaWerks.Dgraph.Types.User do
  alias KarmaWerks.Dgraph

  @stmt """
  first_name: string @index(term) .
  last_name: string @index(term) .
  email: string @index(exact) @upsert .
  password: password .

  type User {
    first_name
    last_name
    email
    password
  }
  """
  def create, do: Dgraph.alter(@stmt)
end
