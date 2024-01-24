defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.DesiredOutcomesForm do
  use SoonReadyInterface, :live_component
  use Ash.Resource, data_layer: :embedded
  import SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Components.Form

  alias __MODULE__.JobStepField

  attributes do
    attribute :job_steps, {:array, JobStepField}, allow_nil?: false, constraints: [min_length: 1]
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form :let={f} for={@form} phx-submit="submit" phx-target={@myself}>
        <div class="flex gap-4">
          <.inputs_for :let={ff} field={f[:job_steps]}>
            <div class="w-80 rounded-lg border border-gray-200 shadow dark:border-gray-700 dark:bg-gray-800">
              <div class="p-4 lg:p-8">
                <.text_field
                  field={ff[:name]}
                  label={"Job Step #{ff.index + 1}"}
                  placeholder="Enter name"
                  class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
                />
              </div>
              <hr>
              <div class="p-4 lg:p-8 flex flex-col gap-2">
                <.inputs_for :let={fff} field={ff[:desired_outcomes]}>
                  <.text_input
                    field={fff[:value]}
                    placeholder="Desired Outcome"
                    class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
                  />
                </.inputs_for>
                <button class="text-primary-600 hover:underline" name={ff.name} type="button" phx-click="add-desired-outcome" phx-target={@myself} phx-value-name={"#{ff.name}"}>Add desired outcome</button>
              </div>
            </div>
          </.inputs_for>

          <div>
            <button class="text-primary-600 hover:underline mb-auto p-4 lg:p-8 w-80 rounded-lg border border-gray-200 shadow dark:border-gray-700 dark:bg-gray-800" type="button" phx-click="add-job-step" phx-target={@myself}>
              Add job step
            </button>
            <%= if f[:job_steps].errors != [] do %>
              <%= for {error, _opts} <- f[:job_steps].errors do %>
                <p class="text-rose-900 dark:text-rose-400"><%= error %></p>
              <% end %>
            <% end %>
          </div>
        </div>

        <button type="submit" name="submit" class="w-full mt-4 py-3 px-5 my-auto text-sm font-medium text-center text-white rounded-lg bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">Proceed</button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(_assigns, socket) do
    socket = assign(socket, :form, AshPhoenix.Form.for_create(__MODULE__, :create, api: SoonReadyInterface.Researcher.Api, forms: [auto?: true]))

    {:ok, socket}
  end

  @impl true
  def handle_event("submit", params, socket) do
    form_params = Map.get(params, "form", %{})
    case AshPhoenix.Form.submit(socket.assigns.form, params: form_params) do
      {:ok, _view_model} ->
        send(self(), {:update_params, %{"desired_outcomes_form" => form_params}})
        send(self(), {:handle_submission, __MODULE__})

        {:noreply, socket}

      {:error, form_with_error} ->
        {:noreply, assign(socket, form: form_with_error)}
    end
  end

  @impl true
  def handle_event("add-job-step", _params, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.add_form(socket.assigns.form, :job_steps, validate?: socket.assigns.form.errors || false))}
  end

  @impl true
  def handle_event("add-desired-outcome", %{"name" => name}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.add_form(socket.assigns.form, "#{name}[desired_outcomes]", validate?: socket.assigns.form.errors || false))}
  end
end
