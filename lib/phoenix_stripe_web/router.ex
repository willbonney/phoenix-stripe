defmodule PhoenixStripeWeb.Router do
  use PhoenixStripeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhoenixStripeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixStripeWeb do
    pipe_through :browser

    live "/", ProjectLive.Index
  end

  scope "/api", PhoenixStripeWeb do
    pipe_through :api

    get "/stripe-key", StripeController, :stripe_key
    post "/create-setup-intent", StripeController, :create_setup_intent
    post "/create-payment-intent", StripeController, :create_payment_intent
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixStripeWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:phoenix_stripe, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PhoenixStripeWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
