defmodule WordleElixirApp.Repo do
  use Ecto.Repo,
    otp_app: :wordle_elixir_app,
    adapter: Ecto.Adapters.Postgres
end
