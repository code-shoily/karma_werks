defmodule KarmaWerks.Dgraph.Types.User do
  @moduledoc """
  Types of User graph.
  """
  alias KarmaWerks.Dgraph

  @stmt """
  name: string @index(term) .
  email: string @index(exact) @upsert .
  password: password .
  bio string @index(term) .
  phone string @index(term) .
  designation string @index(term) .

  type User {
    name
    email
    password
    bio
    phone
    designation
  }
  """
  def create, do: Dgraph.alter(@stmt)
end
