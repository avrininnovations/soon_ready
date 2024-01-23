defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.DesiredOutcomesForm do
  use SoonReadyInterface, :live_component

  use Ash.Resource, data_layer: :embedded

  alias __MODULE__.JobStepField

  attributes do
    attribute :job_steps, {:array, JobStepField}, allow_nil?: false, constraints: [min_length: 1]
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form :let={f} for={@form} phx-submit="submit" phx-target={@myself}>
        <.inputs_for :let={ff} field={f[:job_steps]}>
          <Doggo.input
            field={ff[:name]}
            label={"Job Step #{ff.index + 1}"}
          />

          <.inputs_for :let={fff} field={ff[:desired_outcomes]}>
            <Doggo.input
              field={fff[:value]}
              placeholder="Desired Outcome"
            />
          </.inputs_for>

          <button name={ff.name} phx-click="add-desired-outcome" phx-target={@myself} phx-value-name={"#{ff.name}"}>Add desired outcome</button>
        </.inputs_for>

        <Doggo.button type="submit" name="submit">Proceed</Doggo.button>
      </.form>

      <button phx-click="add-job-step" phx-target={@myself}>Add job step</button>
    </div>
    """
  end

  @impl true
  def update(_assigns, socket) do
    socket = assign(socket, :form, AshPhoenix.Form.for_create(__MODULE__, :create, api: SoonReadyInterface.Researcher.Api, forms: [auto?: true]))

    {:ok, socket}
  end

  @impl true
  def handle_event("submit", %{"form" => form_params}, socket) do
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



  # def handle_event("add-job-step", _params, socket) do
  #   desired_outcomes_form = AshPhoenix.Form.add_form(socket.assigns.desired_outcomes_form, :job_steps, validate?: socket.assigns.desired_outcomes_form.errors || false)
  #   {:noreply, assign(socket, desired_outcomes_form: desired_outcomes_form)}
  # end

  # def handle_event("add-desired-outcome", %{"name" => name} = _params, socket) do
  #   desired_outcomes_form = AshPhoenix.Form.add_form(socket.assigns.desired_outcomes_form, "#{name}[desired_outcomes]", validate?: socket.assigns.desired_outcomes_form.errors || false)
  #   {:noreply, assign(socket, desired_outcomes_form: desired_outcomes_form)}
  # end

end
