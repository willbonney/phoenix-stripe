defmodule PhoenixStripeWeb.ProjectLive.Index do
  use PhoenixStripeWeb, :live_view
  alias PhoenixStripeWeb.ProjectLive.PaymentFormComponent

  def mount(_params, _session, socket) do
    # Mock data for demonstration
    projects = [
      %{id: 1, name: "Project 1", description: "Description 1"},
      %{id: 2, name: "Project 2", description: "Description 2"}
    ]

    {:ok,
     assign(socket,
       projects: projects,
       show_payment_form: false,
       selected_project: nil,
       selected_amount: nil
     )}
  end

  def handle_event("show_payment_form", %{"project_id" => project_id, "amount" => amount}, socket) do
    project = Enum.find(socket.assigns.projects, fn p -> to_string(p.id) == project_id end)

    {:noreply,
     assign(socket, show_payment_form: true, selected_project: project, selected_amount: amount)}
  end

  def handle_event("payment_succeeded", %{"project_id" => project_id, "amount" => amount}, socket) do
    # Handle successful payment
    {:noreply,
     put_flash(socket, :info, "Payment of $#{amount} for Project #{project_id} was successful!")}
  end

  def handle_event("payment_failed", %{"project_id" => project_id, "error" => error}, socket) do
    # Handle failed payment
    {:noreply, put_flash(socket, :error, "Payment for Project #{project_id} failed: #{error}")}
  end

  def render(assigns) do
    ~H"""
    <div class="container mx-auto px-4 py-8">
      <h1 class="text-3xl font-bold mb-8">Projects</h1>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
        <%= for project <- @projects do %>
          <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-xl font-semibold mb-2">{project.name}</h2>
            <p class="text-gray-600 mb-4">{project.description}</p>

            <form phx-submit="show_payment_form" class="space-y-4">
              <input type="hidden" name="project_id" value={project.id} />

              <div>
                <label for={"amount-#{project.id}"} class="block text-sm font-medium text-gray-700">
                  Amount
                </label>
                <input
                  type="number"
                  name="amount"
                  id={"amount-#{project.id}"}
                  min="1"
                  step="0.01"
                  required
                  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                />
              </div>

              <button
                type="submit"
                class="w-full bg-indigo-600 text-white py-2 px-4 rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
              >
                Contribute
              </button>
            </form>
          </div>
        <% end %>
      </div>
      <%= if @show_payment_form and @selected_project do %>
        <.live_component
          module={PaymentFormComponent}
          id="payment-form-component"
          project={@selected_project}
          amount={@selected_amount}
        />
      <% end %>
    </div>
    """
  end
end
