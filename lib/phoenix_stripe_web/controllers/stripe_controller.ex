defmodule PhoenixStripeWeb.StripeController do
  use PhoenixStripeWeb, :controller

  def create_setup_intent(conn, _params) do
    api_key = System.get_env("STRIPE_SECRET_KEY")

    case Stripe.SetupIntent.create(%{}, api_key: api_key) do
      {:ok, setup_intent} ->
        json(conn, %{client_secret: setup_intent.client_secret})

      {:error, error} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: error.message})
    end
  end

  def create_payment_intent(conn, %{"payment_method_id" => payment_method_id, "amount" => amount}) do
    api_key = System.get_env("STRIPE_SECRET_KEY")

    with {:ok, customer} <-
           Stripe.Customer.create(%{email: "test@example.com"}, api_key: api_key),
         {:ok, _} <-
           Stripe.PaymentMethod.attach(
             %{customer: customer.id, payment_method: payment_method_id},
             api_key: api_key
           ),
         {:ok, _payment_intent} <-
           Stripe.PaymentIntent.create(
             %{
               amount: String.to_integer(amount) * 100,
               currency: "usd",
               customer: customer.id,
               payment_method: payment_method_id,
               off_session: true,
               confirm: true
             },
             api_key: api_key
           ) do
      json(conn, %{status: "succeeded"})
    else
      {:error, error} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{status: "failed", error: error.message})
    end
  end

  def stripe_key(conn, _params) do
    json(conn, %{stripeKey: System.get_env("STRIPE_PUBLISHABLE_KEY")})
  end
end
