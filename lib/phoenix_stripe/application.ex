defmodule PhoenixStripe.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Dotenv.load()

    children = [
      PhoenixStripeWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:phoenix_stripe, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhoenixStripe.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhoenixStripe.Finch},
      # Start a worker by calling: PhoenixStripe.Worker.start_link(arg)
      # {PhoenixStripe.Worker, arg},
      # Start to serve requests, typically the last entry
      PhoenixStripeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixStripe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixStripeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
