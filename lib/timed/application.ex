defmodule Timed.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TimedWeb.Telemetry,
      Timed.Repo,
      {DNSCluster, query: Application.get_env(:timed, :dns_cluster_query) || :ignore},
      {Oban,
       AshOban.config(
         Application.fetch_env!(:timed, :ash_domains),
         Application.fetch_env!(:timed, Oban)
       )},
      {Phoenix.PubSub, name: Timed.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Timed.Finch},
      # Start a worker by calling: Timed.Worker.start_link(arg)
      # {Timed.Worker, arg},
      # Start to serve requests, typically the last entry
      TimedWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :timed]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Timed.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TimedWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
