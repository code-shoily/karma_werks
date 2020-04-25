defmodule KarmaWerks.Cache do
  use Nebulex.Cache,
    otp_app: :karma_werks,
    adapter: Nebulex.Adapters.Local
end
