defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.ContextQuestionsForm do
  use SoonReadyInterface, :live_component

  use Ash.Resource, data_layer: :embedded

  alias __MODULE__.ContextQuestionField

  attributes do
    attribute :context_questions, {:array, ContextQuestionField}, allow_nil?: false
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form :let={f} for={@form} phx-submit="submit" phx-target={@myself}>
        <.inputs_for :let={ff} field={f[:context_questions]}>
          <Doggo.input
            field={ff[:prompt]}
            label="Prompt"
          />

          <.inputs_for :let={fff} field={ff[:options]}>
            <Doggo.input
              field={fff[:value]}
              placeholder="Option"
            />
          </.inputs_for>

          <button name={ff.name} phx-click="add-context-question-option" phx-target={@myself} phx-value-name={"#{ff.name}"}>Add option</button>
        </.inputs_for>

        <Doggo.button type="submit" name="submit">Proceed</Doggo.button>
      </.form>

      <button phx-click="add-context-question" phx-target={@myself}>Add context question</button>
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
        send(self(), {:update_params, %{"context_questions_form" => form_params}})
        send(self(), {:handle_submission, __MODULE__})

        {:noreply, socket}

      {:error, form_with_error} ->
        {:noreply, assign(socket, form: form_with_error)}
    end
  end

  @impl true
  def handle_event("add-context-question", _params, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.add_form(socket.assigns.form, :context_questions, validate?: socket.assigns.form.errors || false))}
  end

  @impl true
  def handle_event("add-context-question-option", %{"name" => name} = _params, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.add_form(socket.assigns.form, "#{name}[options]", validate?: socket.assigns.form.errors || false))}
  end
end
