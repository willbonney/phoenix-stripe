defmodule PhoenixStripeWeb.ProjectLive.PaymentFormComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div id="payment-form-root" class="mx-auto max-w-2xl py-8" phx-hook="PaymentFormStripe">
      <h1 class="text-2xl font-bold mb-4">Test Stripe Payment</h1>
      <div id="stripe-form-container" phx-update="ignore">
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
          <button
            type="submit"
            class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 flex items-center justify-center min-w-[120px]"
            disabled={@loading}
          >
            <%= if @loading do %>
              <svg
                class="animate-spin h-5 w-5 mr-2 text-white"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
              >
                <circle
                  class="opacity-25"
                  cx="12"
                  cy="12"
                  r="10"
                  stroke="currentColor"
                  stroke-width="4"
                >
                </circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z">
                </path>
              </svg>
              Processing...
            <% else %>
              Pay Now
            <% end %>
          </button>
        </form>
      </div>
    </div>
    """
  end
end
