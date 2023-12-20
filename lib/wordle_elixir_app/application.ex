defmodule WordleElixirApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WordleElixirAppWeb.Telemetry,
      WordleElixirApp.Repo,
      {DNSCluster, query: Application.get_env(:wordle_elixir_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: WordleElixirApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: WordleElixirApp.Finch},
      # Start a worker by calling: WordleElixirApp.Worker.start_link(arg)
      # {WordleElixirApp.Worker, arg},
      # Start to serve requests, typically the last entry
      WordleElixirAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WordleElixirApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WordleElixirAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
