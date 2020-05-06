defmodule KarmaWerks.Cache do
  @moduledoc false

  use Nebulex.Cache,
    otp_app: :karma_werks,
    adapter: Nebulex.Adapters.Local
end
