defmodule KarmaWerks.Repo do
  use Ecto.Repo,
    otp_app: :karma_werks,
    adapter: Ecto.Adapters.Postgres
end
