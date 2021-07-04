defmodule RushingStatistics.Repo do
  use Ecto.Repo,
    otp_app: :rushing_statistics,
    adapter: Ecto.Adapters.Postgres
end
