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
      <.form :let={f} for={@form} phx-change="validate" phx-submit="submit" phx-target={@myself}>
        <div class="flex gap-4">
          <.inputs_for :let={ff} field={f[:job_steps]}>
            <div class="w-80 rounded-lg border border-gray-200 shadow dark:border-gray-700 dark:bg-gray-800">
              <div class="p-4 lg:p-8">
                <div class="flex justify-between my-2">
                  <h3 class="text-lg font-semibold items-center">Job Step <%= ff.index + 1 %></h3>
                  <.thrash_button phx-click="remove-job-step" phx-value-name={"#{ff.name}"} phx-target={@myself}>
                    Remove Job Step
                  </.thrash_button>
                </div>

                <.text_input
                  field={ff[:name]}
                  placeholder="Enter name"
                  class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
                />
              </div>
              <hr>
              <div class="p-4 lg:p-8 flex flex-col gap-2">
                <.inputs_for :let={fff} field={ff[:desired_outcomes]}>
                  <div class="flex justify-between">
                    <.text_input
                      field={fff[:value]}
                      placeholder="Desired Outcome"
                      class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
                    />
                    <.thrash_button phx-click="remove-desired-outcome" phx-value-name={"#{fff.name}"} phx-target={@myself}>
                      Remove Desired Outcome
                    </.thrash_button>
                  </div>
                </.inputs_for>
                <button class="p-2 text-primary-600 hover:underline hover:border-primary-500 rounded-lg border border-gray-300 shadow-sm" name={ff.name} type="button" phx-click="add-desired-outcome" phx-target={@myself} phx-value-name={"#{ff.name}"}>
                  Add desired outcome
                </button>
                <.errors field={ff[:desired_outcomes]} />
              </div>
            </div>
          </.inputs_for>

          <div>
            <button class="text-primary-600 hover:underline mb-auto p-4 lg:p-8 w-80 rounded-lg border border-gray-200 shadow dark:border-gray-700 dark:bg-gray-800" type="button" phx-click="add-job-step" phx-target={@myself}>
              Add job step
            </button>
            <.errors field={f[:job_steps]} />
          </div>
        </div>

        <button type="submit" name="submit" class="w-full mt-4 py-3 px-5 my-auto text-sm font-medium text-center text-white rounded-lg bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">Proceed</button>
      </.form>
    </div>
    """
  end

  attr :rest, :global
  def thrash_button(assigns) do
    ~H"""
    <button type="button" {@rest} class="text-primary-700 border border-primary-700 hover:bg-primary-700 hover:text-white focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm p-2.5 text-center inline-flex items-center dark:border-primary-500 dark:text-primary-500 dark:hover:text-white dark:focus:ring-primary-800 dark:hover:bg-primary-500">
      <svg class="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 7h14m-9 3v8m4-8v8M10 3h4a1 1 0 0 1 1 1v3H9V4a1 1 0 0 1 1-1ZM6 7h12v13a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1V7Z"/>
      </svg>
      <span class="sr-only"><%= render_slot(@inner_block) %></span>
    </button>
    """
  end

  @impl true
  def update(_assigns, socket) do
    socket = assign(socket, :form, AshPhoenix.Form.for_create(__MODULE__, :create, api: SoonReadyInterface.Researcher.Api, forms: [auto?: true]))

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", params, socket) do
    form_params = Map.get(params, "form", %{})
    validated_form = AshPhoenix.Form.validate(socket.assigns.form, form_params, errors: socket.assigns.form.errors || false)
    {:noreply, assign(socket, form: validated_form)}
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
  def handle_event("remove-job-step", %{"name" => name}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.remove_form(socket.assigns.form, name, validate?: socket.assigns.form.errors || false))}
  end

  @impl true
  def handle_event("remove-desired-outcome", %{"name" => name}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.remove_form(socket.assigns.form, name, validate?: socket.assigns.form.errors || false))}
  end

  @impl true
  def handle_event("add-desired-outcome", %{"name" => name}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.add_form(socket.assigns.form, "#{name}[desired_outcomes]", validate?: socket.assigns.form.errors || false))}
  end
end
