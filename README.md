# KarmaWerks

Checklist and Prerequisites:

* Elixir 1.10.x
* Docker (Or the latest version of DGraph)
* Node and NPM

To start your Phoenix server:

* Install and run Dgraph from `https://dgraph.io/downloads`
  - or, `docker-compose up`
* Setup the project with `mix setup`
* Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Running the tests:

`mix test` command starts a separate Dgraph instance via `scripts/start_dgraph.sh`. It listens to port `19080`. The container can be stopped with `scripts/stop_dgraph.sh` and all data is removed when done so.

Regarding Dgraph ports:

If you have to change any of the ports of Dgraph due to conflict, please reflect it on `config/dev.exs` and/or `config.test.exs`. (`config :karma_werks, :dgraph_port`). In `prod.exs` it should contain environment variables according to your production setup.

## Technologies Used <3

* Elixir: http://elixir-lang.org/
* Phoenix: https://www.phoenixframework.org/
* Dgraph: https://dgraph.io/
* Bulma: https://bulma.io/
