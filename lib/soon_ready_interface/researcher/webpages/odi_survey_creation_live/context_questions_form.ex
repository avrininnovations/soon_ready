defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.ContextQuestionsForm do
  use SoonReadyInterface, :live_component
  use Ash.Resource, data_layer: :embedded
  import SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Components.Form

  alias __MODULE__.{ContextQuestionField, MultipleChoiceQuestion, CheckboxQuestion}

  attributes do
    attribute :context_questions, {:array, ContextQuestionField}, allow_nil?: false, public?: true
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.card_form :let={f} for={@form} phx-change="validate" phx-submit="submit" target={@myself}>
        <.inputs_for :let={ff} field={f[:context_questions]}>
          <%= case ff.source.resource do %>
            <% MultipleChoiceQuestion -> %>
              <.mcq_card form={ff} target={@myself} />
            <% CheckboxQuestion -> %>
              <.checkbox_card form={ff} target={@myself} />
          <% end %>
        </.inputs_for>

        <div class="flex flex-col gap-4">
          <.add_button name="add-multiple-choice-question" target={@myself} action="add-multiple-choice-question" field={f[:context_questions]}> Add Multiple Choice Question </.add_button>
          <.add_button name="add-checkbox-question" target={@myself} action="add-checkbox-question" field={f[:context_questions]}> Add Checkbox Question </.add_button>
        </div>
        <:submit>Proceed</:submit>
      </.card_form>
    </div>
    """
  end

  def mcq_card(assigns) do
    ~H"""
    <.card>
      <:header>
        <.card_header>
          <:title>MCQ Prompt</:title>
          <:thrash_button click="remove-context-question" name={"#{@form.name}"} target={@target}>Remove Context Question</:thrash_button>
          <:text_input field={@form[:prompt]} placeholder="Enter prompt" />
        </.card_header>
      </:header>
      <:body>
        <.inputs_for :let={f} field={@form[:options]}>
          <.card_field>
            <:text_input field={f[:value]} placeholder="Option" />
            <:thrash_button click="remove-context-question-option" name={"#{f.name}"} target={@target}>Remove Context Question Option</:thrash_button>
          </.card_field>
        </.inputs_for>
      </:body>
      <:add_button name={@form.name} action="add-context-question-option" target={@target} field={@form[:options]}> Add option </:add_button>
    </.card>
    """
  end

  def checkbox_card(assigns) do
    ~H"""
    <.card>
      <:header>
        <.card_header>
          <:title>Checkbox Prompt</:title>
          <:thrash_button click="remove-context-question" name={"#{@form.name}"} target={@target}>Remove Context Question</:thrash_button>
          <:text_input field={@form[:prompt]} placeholder="Enter prompt" />
        </.card_header>
      </:header>
      <:body>
        <.inputs_for :let={f} field={@form[:options]}>
          <.card_field>
            <:text_input field={f[:value]} placeholder="Option" />
            <:thrash_button click="remove-context-question-option" name={"#{f.name}"} target={@target}>Remove Context Question Option</:thrash_button>
          </.card_field>
        </.inputs_for>
      </:body>
      <:add_button name={@form.name} action="add-context-question-option" target={@target} field={@form[:options]}> Add option </:add_button>
    </.card>
    """
  end

  @impl true
  def update(_assigns, socket) do
    socket = assign(socket, :form, AshPhoenix.Form.for_create(__MODULE__, :create, domain: SoonReadyInterface.Researcher.Domain, forms: [auto?: true]))

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
        send(self(), {:update_params, %{"context_questions_form" => form_params}})
        send(self(), {:handle_submission, __MODULE__})

        {:noreply, socket}

      {:error, form_with_error} ->
        {:noreply, assign(socket, form: form_with_error)}
    end
  end

  @impl true
  def handle_event("add-multiple-choice-question", _params, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.add_form(socket.assigns.form, :context_questions, params: %{"_union_type" => "#{MultipleChoiceQuestion}"}, validate?: socket.assigns.form.errors || false))}
  end

  @impl true
  def handle_event("add-checkbox-question", _params, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.add_form(socket.assigns.form, :context_questions, params: %{"_union_type" => "#{CheckboxQuestion}"}, validate?: socket.assigns.form.errors || false))}
  end

  @impl true
  def handle_event("add-context-question-option", %{"name" => name} = _params, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.add_form(socket.assigns.form, "#{name}[options]", validate?: socket.assigns.form.errors || false))}
  end

  @impl true
  def handle_event("remove-context-question", %{"name" => name}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.remove_form(socket.assigns.form, name, validate?: socket.assigns.form.errors || false))}
  end

  @impl true
  def handle_event("remove-context-question-option", %{"name" => name}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.remove_form(socket.assigns.form, name, validate?: socket.assigns.form.errors || false))}
  end
end
