# KarmaWerks

Checklist and Prerequisites:

* Elixir 1.10.x
* Docker (Or the latest version of DGraph)
* Node and NPM

To start your Phoenix server:

* Run the database server with `scripts/start_dgraph.sh `
* Setup the project with `mix setup`
* Start Phoenix endpoint with `DGRAPH_PORT=9090 mix phx.server`

*NOTE* If you get any port conflicts, edit the ports in `scripts/start_dgraph.sh` and use that in `DGRAPH_PORT`.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Technologies Used <3

* Elixir: http://elixir-lang.org/
* Phoenix: https://www.phoenixframework.org/
* Dgraph: https://dgraph.io/
* Bulma: https://bulma.io/
