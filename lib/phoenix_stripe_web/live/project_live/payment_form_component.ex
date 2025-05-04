defmodule PhoenixStripeWeb.ProjectLive.PaymentFormComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div id="payment-form-root" class="mx-auto max-w-2xl py-8" phx-hook="PaymentFormStripe">
      <h1 class="text-2xl font-bold mb-4">Test Stripe Payment</h1>
      <form id="payment-form" class="space-y-4">
        <div>
          <label for="amount" class="block text-sm font-medium">Amount (USD)</label>
          <input
            type="number"
            id="amount"
            name="amount"
            class="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
            value={@amount}
            min="1"
          />
        </div>
        <div id="card-element" class="mt-4 p-4 border rounded-md">
          <!-- Stripe Elements will be inserted here -->
        </div>
        <div id="card-errors" class="mt-2 text-red-600" role="alert"></div>
        <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
          Pay Now
        </button>
      </form>
    </div>
    """
  end
end
