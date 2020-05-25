defmodule KarmaWerks.Dgraph do
  @moduledoc false

  @type conn :: DBConnection.conn()
  @type uid :: String.t()
  @type query :: iodata
  @type query_map :: %{:query => query, optional(:vars) => map}
  @type statement :: iodata | map
  @type mutation :: %{
          optional(:cond) => iodata,
          optional(:set) => statement(),
          optional(:delete) => statement()
        }
  @type mutations :: [mutation]

  @db_process KarmaWerks.DgraphProcess

  @doc """
  Alter dgraph schema

  ## Example

      iex> KarmaWerks.Dgraph.alter("name: string @index(term) .")
      {:ok, ""}

  ## Options

    * `:timeout` - Call timeout

  """
  @spec alter(statement, Keyword.t()) :: {:ok, map} | {:error, Dlex.Error.t() | term}
  def alter(statement, opts \\ []), do: Dlex.alter(@db_process, statement, opts)

  @doc """
  Send mutation to dgraph. Shortcut for `mutate(query, %{set: statement}, opts)`

  Options:

    * `return_json` - if json with uids should be returned (default: `false`)

  Example of usage

      iex> mutation = "
           _:foo <name> "Foo" .
           _:foo <owns> _:bar .
            _:bar <name> "Bar" .
           "
      iex> KarmaWerks.Dgraph.set(mutation)
      {:ok, %{uids: %{"bar" => "0xfe04c", "foo" => "0xfe04b"}, queries: %{}}}

  Using `json`

      iex> json = %{"name" => "Foo", "owns" => [%{"name" => "Bar"}]}
           KarmaWerks.Dgraph.set(conn, json)
      {:ok, %{uids: %{"blank-0" => "0xfe04d", "blank-1" => "0xfe04e"}, queries: %{}}}
      iex> KarmaWerks.Dgraph.set(conn, json, return_json: true)
      {:ok,
       %{json: %{
         "name" => "Foo",
         "owns" => [%{"name" => "Bar", "uid" => "0xfe050"}],
         "uid" => "0xfe04f"
       }}}

  ## Options

    * `:timeout` - Call timeout

  """
  @spec set(query_map, statement, Keyword.t()) :: {:ok, map} | {:error, Dlex.Error.t() | term}
  def set(query, statement, opts), do: mutate(query, [%{set: statement}], opts)

  @doc """
  The same as `Dlex.set(conn, "", statement, [])`
  """
  @spec set(statement) :: {:ok, map} | {:error, Dlex.Error.t() | term}
  def set(statement), do: mutate(%{query: ""}, [%{set: statement}], [])

  @doc """
  The same as `Dlex.set(conn, "", statement, opts)`.
  """
  @spec set(query_map | statement, statement | Keyword.t()) ::
          {:ok, map} | {:error, Dlex.Error.t() | term}
  def set(%{query: _} = query, statement), do: mutate(query, [%{set: statement}], [])
  def set(statement, opts), do: set(statement, opts)

  @doc """
  Send mutation to dgraph

  Options:

    * `return_json` - if json with uids should be returned (default: `false`)

  Example of usage

      iex> mutation = "
           _:foo <name> "Foo" .
           _:foo <owns> _:bar .
            _:bar <name> "Bar" .
           "
      iex> Dlex.mutate(conn, %{set: mutation})
      {:ok, %{uids: %{"bar" => "0xfe04c", "foo" => "0xfe04b"}, queries: %{}}}
  Using `json`
      iex> json = %{"name" => "Foo", "owns" => [%{"name" => "Bar"}]}
           Dlex.mutate(conn, %{set: json})
      {:ok, %{uids: %{"blank-0" => "0xfe04d", "blank-1" => "0xfe04e"}, queries: %{}}}
      iex> Dlex.mutate(conn, %{set: json}, return_json: true)
      {:ok,
       %{json: %{
         "name" => "Foo",
         "owns" => [%{"name" => "Bar", "uid" => "0xfe050"}],
         "uid" => "0xfe04f"
       }}}

  ## Options

    * `:timeout` - Call timeout

  """
  @spec mutate(query_map, mutations, Keyword.t()) ::
          {:ok, map} | {:error, Dlex.Error.t() | term}
  def mutate(query_map, mutations, opts), do: Dlex.mutate(@db_process, query_map, mutations, opts)

  @doc """
  The same as `KarmaWerks.Dgraph.mutate(%{}, mutations, [])`
  """
  @spec mutate(mutations) :: {:ok, map} | {:error, Dlex.Error.t() | term}
  def mutate(mutations), do: mutate(%{query: ""}, mutations, [])

  @doc """
  The same as `KarmaWerks.Dgraph.mutate("", mutations, opts)`.
  """
  @spec mutate(query_map | mutations, mutations | Keyword.t()) ::
          {:ok, map} | {:error, Dlex.Error.t() | term}
  def mutate(%{query: _} = query, mutations), do: Dlex.mutate(@db_process, query, mutations)
  def mutate(mutations, opts), do: Dlex.mutate(@db_process, mutations, opts)

  @doc """
  Send delete mutation to dgraph

  Options:

    * `return_json` - if json with uids should be returned (default: `false`)

  Example of usage

      iex> KarmaWerks.Dgraph.delete(conn, %{"uid" => "0xfe04c"})
      {:ok, %{queries: %{}, uids: %{}}}

  Using `json`

      iex> json = %{"uid" => "0xfe04c"}
           KarmaWerks.Dgraph.delete(conn, json)
      {:ok, %{queries: %{}, uids: %{}}}
      iex> KarmaWerks.Dgraph.delete(conn, json, return_json: true)
      {:ok, %{json: %{"uid" => "0xfe04c"}, queries: %{}, uids: %{}}}

  ## Options

    * `:timeout` - Call timeout

  """
  @spec delete(query_map, statement, Keyword.t()) :: {:ok, map} | {:error, Dlex.Error.t() | term}
  def delete(query_map, statement, opts), do: mutate(query_map, [%{delete: statement}], opts)

  @doc """
  The same as `KarmaWerks.Dgraph.delete(conn, "", deletion, [])`
  """
  @spec delete(statement) :: {:ok, map} | {:error, Dlex.Error.t() | term}
  def delete(statement), do: delete(%{query: ""}, statement, [])

  @doc """
  The same as `KarmaWerks.Dgraph.delete(query, deletion, [])` or `KarmaWerks.Dgraph.delete("", deletion, opts)`
  """
  @spec delete(query | statement, statement | Keyword.t()) ::
          {:ok, map} | {:error, Dlex.Error.t() | term}
  def delete(%{query: _} = query, statement),
    do: delete(query, statement, [])

  def delete(statement, opts), do: delete(%{query: ""}, statement, opts)

  @doc """
  Send query to dgraph

  Example of usage

      iex> query = "
           query foo($a: string) {
              foo(func: eq(name, $a)) {
                uid
                expand(_all_)
              }
            }
           "
      iex> KarmaWerks.Dgraph.query(query, %{"$a" => "Foo"})
      {:ok, %{"foo" => [%{"name" => "Foo", "uid" => "0xfe04d"}]}}

  Query options (see DGraph documentation for more information):

      * `best_effort` - `boolean`
      * `read_only` - `boolean`

  """
  @spec query(iodata, map, Keyword.t()) :: {:ok, map} | {:error, Dlex.Error.t() | term}
  def query(statement, parameters \\ %{}, opts \\ []),
    do: Dlex.query(@db_process, statement, parameters, opts)

  @doc """
  Query schema of dgraph
  """
  @spec query_schema() :: {:ok, map} | {:error, Dlex.Error.t() | term}
  def query_schema, do: query("schema {}")

  @doc """
  Execute serie of queries and mutations in a transactions
  """
  @spec transaction((DBConnection.t() -> result :: any), Keyword.t()) ::
          {:ok, result :: any} | {:error, any}
  def transaction(fun, opts \\ []), do: Dlex.transaction(@db_process, fun, opts)
end
