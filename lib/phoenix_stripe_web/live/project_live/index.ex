defmodule PhoenixStripeWeb.ProjectLive.Index do
  use PhoenixStripeWeb, :live_view
  alias PhoenixStripeWeb.ProjectLive.PaymentFormComponent

  def mount(_params, _session, socket) do
    projects = [
      %{
        id: 1,
        name: "Plant a Tree",
        description: "Support reforestation efforts around the world.",
        color: "bg-green-50 border-green-300",
        icon: "🌳"
      },
      %{
        id: 2,
        name: "Clean Water Initiative",
        description: "Help provide clean water to communities in need.",
        color: "bg-blue-50 border-blue-300",
        icon: "💧"
      },
      %{
        id: 3,
        name: "Feed the Hungry",
        description: "Contribute to food banks and hunger relief programs.",
        color: "bg-yellow-50 border-yellow-300",
        icon: "🍎"
      },
      %{
        id: 4,
        name: "Education for All",
        description: "Fund scholarships and educational resources for children.",
        color: "bg-purple-50 border-purple-300",
        icon: "📚"
      }
    ]

    {:ok,
     assign(socket,
       projects: projects,
       show_payment_form: false,
       selected_amount: nil,
       loading: false
     )}
  end

  def handle_event("show_payment_form", %{"amount" => amount}, socket) do
    {:noreply,
     assign(socket,
       show_payment_form: true,
       selected_amount: amount
     )}
  end

  def handle_event("payment_succeeded", %{"amount" => amount}, socket) do
    IO.inspect(amount, label: "success")

    {:noreply,
     put_flash(socket, :info, "Payment of $#{amount} was successful!") |> assign(:loading, false)}
  end

  def handle_event("payment_failed", %{"error" => error}, socket) do
    {:noreply, put_flash(socket, :error, "Payment failed: #{error}") |> assign(:loading, false)}
  end

  def handle_event("set_loading", %{"loading" => loading}, socket) do
    IO.inspect(loading, label: "loading type")
    {:noreply, socket |> assign(:loading, loading)}
  end

  def render(assigns) do
    ~H"""
    <.flash_group flash={@flash} />
    <div class="container mx-auto px-4 py-8">
      <h1 class="text-3xl font-bold mb-8 text-center">Support Social Good Projects</h1>
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <%= for project <- @projects do %>
          <div class={"max-w-md w-full rounded-2xl shadow-xl p-6 border #{project.color} flex flex-col items-center transition-transform hover:scale-105 bg-white min-h-[370px] mx-auto"}>
            <div class="text-6xl mb-3 drop-shadow-sm">{project.icon}</div>
            <h2 class="text-lg font-bold mb-1 text-center text-gray-900">{project.name}</h2>
            <p class="text-gray-700 mb-4 text-center text-sm">{project.description}</p>
            <form phx-submit="show_payment_form" class="space-y-3 w-full flex flex-col items-center">
              <div class="w-full">
                <label
                  for={"amount-#{project.id}"}
                  class="block text-xs font-medium text-gray-700 mb-1"
                >
                  Amount
                </label>
                <input
                  type="number"
                  name="amount"
                  id={"amount-#{project.id}"}
                  min="1"
                  step="0.01"
                  required
                  class="block w-full rounded-md border border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-center text-base py-1"
                />
              </div>
              <input type="hidden" name="project_id" value={project.id} />
              <button
                type="submit"
                class="mt-2 w-32 bg-gradient-to-r from-green-400 via-blue-500 to-purple-500 text-white py-2 px-4 rounded-lg font-bold shadow-lg hover:from-green-500 hover:via-blue-600 hover:to-purple-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors text-base"
              >
                Contribute
              </button>
            </form>
          </div>
        <% end %>
      </div>
      <%= if @show_payment_form do %>
        <.live_component
          module={PaymentFormComponent}
          id="payment-form-component"
          amount={@selected_amount}
          loading={@loading}
        />
      <% end %>
    </div>
    """
  end
end
