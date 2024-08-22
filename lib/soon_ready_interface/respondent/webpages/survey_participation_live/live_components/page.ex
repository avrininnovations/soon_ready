defmodule SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.LiveComponents.Page do
  use SoonReadyInterface, :live_component

  import SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.Components.Form
  import SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.Components.Layout

  alias SoonReady.SurveyManagement.V1.DomainConcepts.{
    Transition,
    ShortAnswerQuestion,
    MultipleChoiceQuestion,
    CheckboxQuestion,
    OptionWithCorrectFlag,
    ParagraphQuestion,
    ShortAnswerQuestionGroup,
    MultipleChoiceQuestionGroup,
  }

  alias SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.FormViewModel

  @impl true
  def update(assigns, socket) do
    view_model = create_response_view_model(assigns.current_page)

    socket =
      socket
      |> assign(:has_mcq_group_question, assigns.has_mcq_group_question)
      |> assign(:current_page, assigns.current_page)
      |> assign(:form, AshPhoenix.Form.for_update(view_model, :submit, domain: SoonReadyInterface.Respondent, forms: [auto?: true]))

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    # <div id="accordion-open" data-accordion="open">
    accordion_attrs =
      if assigns.has_mcq_group_question do
        %{id: "accordion-open", "data-accordion": "open"}
      else
        %{}
      end
    assigns = assign(assigns, :accordion_attrs, accordion_attrs)
    ~H"""
    <div>
      <.form :let={f} for={@form} phx-change="validate" phx-submit="submit" phx-target={@myself} class="flex flex-col gap-2">
        <div {@accordion_attrs}>
          <.inputs_for :let={ff} field={f[:responses]}>
            <%= case ff.source.resource do %>
              <% FormViewModel.ShortAnswerQuestionResponse -> %>
                <.text_field
                  field={ff[:response]}
                  label={ff.data.prompt}
                  class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
                />
              <% FormViewModel.MultipleChoiceQuestionResponse -> %>
                <.radio_group
                  field={ff[:response]}
                  label={ff.data.prompt}
                  options={Enum.map(ff.data.options, fn option -> {option, option} end)}
                />
              <% FormViewModel.CheckboxQuestionResponse -> %>
                <.checkbox_group
                  field={ff[:responses]}
                  label={ff.data.prompt}
                  options={Enum.map(ff.data.options, fn option -> {option, option} end)}
                />
              <% FormViewModel.ParagraphQuestionResponse -> %>
                <.textarea
                  field={ff[:response]}
                  label={ff.data.prompt}
                  class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
                />
              <% FormViewModel.MultipleChoiceQuestionGroupResponse -> %>
                <.mcq_group
                  form={ff}
                  index={ff.index}
                  title={ff.data.title}
                  questions={ff.data.questions}
                />
              <% FormViewModel.ShortAnswerQuestionGroupResponse -> %>
                <.short_answer_group
                  form={ff}
                  group_prompt={ff.data.group_prompt}
                  add_button_label={ff.data.add_button_label}
                  target={@myself}
                />
            <% end %>
          </.inputs_for>
        </div>

        <button type="submit" name="submit" class="mt-4 py-3 px-5 my-auto text-sm font-medium text-center text-white rounded-lg bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">Proceed</button>
      </.form>
    </div>
    """
  end

  def mcq_group(assigns) do
    # TODO: How do I handle index?

    # TODO: Rename ODI related component, attr and slot names
    ~H"""
    <.accordion index={@index}>
      <:title><%= @title %></:title>

      <.rating_section>
        <.rating_section_header questions={@questions} />

        <.rating_section_body>
          <.inputs_for :let={prompt_form} field={@form[:prompt_responses]}>
            <.outcome_rating desired_outcome={prompt_form.data.prompt}>
              <.inputs_for :let={question_form} field={prompt_form[:question_responses]}>
                <.rating_radio_group field={question_form[:response]} options={question_form.data.options} />
              </.inputs_for>
            </.outcome_rating>
          </.inputs_for>
        </.rating_section_body>
      </.rating_section>
    </.accordion>
    """
  end

  def short_answer_group(assigns) do
    ~H"""
    <div>
      <h3 class="block mb-2 font-medium text-gray-900 dark:text-white"><%= @group_prompt %></h3>

      <.inputs_for :let={f} field={@form[:responses]}>
        <div class="flex my-2 gap-2">
          <.inputs_for :let={ff} field={f[:question_responses]}>
            <.hidden_input field={ff[:id]} />
            <.hidden_input field={ff[:prompt]} />
            <.text_field
              field={ff[:response]}
              label={ff.source.source.attributes.prompt}
              class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
            />
          </.inputs_for>
          <.thrash_button action="remove-short-answer-group-response" name={f.name} target={@target} sr_description="Remove Response" />
        </div>
      </.inputs_for>

      <.add_button name={@form.name} index={@form.index} target={@target} action="add-short-answer-group-response" field={@form[:responses]}><%= @add_button_label %></.add_button>
    </div>
    """
  end

  attr :field, Phoenix.HTML.FormField, required: true
  attr :name, :string, required: true
  attr :index, :string, required: true
  attr :action, :string, required: true
  attr :target, :string, required: true
  slot :inner_block, required: true
  def add_button(assigns) do
    ~H"""
    <button name={@name} phx-click={@action} phx-target={@target} phx-value-name={@name} phx-value-index={@index} type="button"
      class="p-2 text-primary-600 hover:underline hover:border-primary-500 rounded-lg border border-gray-300 shadow-sm"
    >
      <%= render_slot(@inner_block) %>
    </button>
    <.errors field={@field} />
    """
  end

  attr :action, :string, required: true
  attr :name, :string, required: true
  attr :target, :string, required: true
  attr :sr_description, :string, required: true
  def thrash_button(assigns) do
    ~H"""
    <button type="button" phx-click={@action} phx-value-name={@name} phx-target={@target} class="text-primary-700 border border-primary-700 hover:bg-primary-700 hover:text-white focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm p-2.5 text-center inline-flex items-center dark:border-primary-500 dark:text-primary-500 dark:hover:text-white dark:focus:ring-primary-800 dark:hover:bg-primary-500">
      <svg class="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 7h14m-9 3v8m4-8v8M10 3h4a1 1 0 0 1 1 1v3H9V4a1 1 0 0 1 1-1ZM6 7h12v13a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1V7Z"/>
      </svg>
      <span class="sr-only"><%= @sr_description %></span>
    </button>
    """
  end

  attr :field, Phoenix.HTML.FormField, required: true
  attr :rest, :global

  def hidden_input(assigns) do
    ~H"""
    <div>
      <%= hidden_input(@field.form, @field.field, Keyword.new(@rest)) %>
    </div>
    """
  end
  def create_response_view_model(%{questions: questions, transitions: page_transitions} = _survey_page) do
    responses =
      questions
      |> Enum.map(fn
        %Ash.Union{type: ShortAnswerQuestion, value: %ShortAnswerQuestion{id: id, prompt: prompt}} ->
          %{type: "short_answer_question_response", id: id, prompt: prompt}
        %Ash.Union{type: MultipleChoiceQuestion, value: %MultipleChoiceQuestion{id: id, prompt: prompt, options: options}} ->
          options = Enum.map(options, fn
            %Ash.Union{type: OptionWithCorrectFlag, value: %OptionWithCorrectFlag{value: value}} ->
              value
            %Ash.Union{type: :ci_string, value: value} ->
              value
          end)
          %{type: "multiple_choice_question_response", id: id, prompt: prompt, options: options}
        %Ash.Union{type: CheckboxQuestion, value: %CheckboxQuestion{id: id, prompt: prompt, options: options, correct_answer_criteria: correct_answer_criteria}} ->
          options = Enum.map(options, fn
            %Ash.Union{type: OptionWithCorrectFlag, value: %OptionWithCorrectFlag{value: value}} ->
              value
            %Ash.Union{type: :ci_string, value: value} ->
              value
          end)
          %{type: "checkbox_question_response", id: id, prompt: prompt, options: options, correct_answer_criteria: correct_answer_criteria}
        %Ash.Union{type: ParagraphQuestion, value: %ParagraphQuestion{id: id, prompt: prompt}} ->
          %{type: "paragraph_question_response", id: id, prompt: prompt}
        %Ash.Union{type: ShortAnswerQuestionGroup, value: %ShortAnswerQuestionGroup{id: id, group_prompt: group_prompt, add_button_label: add_button_label, questions: questions}} ->
          questions = Enum.map(questions, fn %{id: id, prompt: prompt} = _question ->
            %{id: id, prompt: prompt}
          end)
          # %{type: "short_answer_question_group_response", id: id, group_prompt: group_prompt, add_button_label: add_button_label, responses: responses}
          %{type: "short_answer_question_group_response", id: id, group_prompt: group_prompt, add_button_label: add_button_label, questions: questions}
        %Ash.Union{type: MultipleChoiceQuestionGroup, value: %MultipleChoiceQuestionGroup{id: id, title: title, prompts: prompts, questions: questions}} ->
          prompt_responses = Enum.map(prompts, fn %{id: id, prompt: prompt} ->
            question_responses = Enum.map(questions, fn %{id: id, prompt: prompt, options: options} ->
              options = Enum.map(options, fn
                %Ash.Union{value: option, type: :ci_string} -> option
              end)
              %{id: id, prompt: prompt, options: options}
            end)
            %{id: id, prompt: prompt, question_responses: question_responses}
          end)

          prompts = Enum.map(prompts, fn %{id: id, prompt: prompt} = _prompt -> %{id: id, prompt: prompt} end)
          questions = Enum.map(questions, fn %{id: id, prompt: prompt, options: options} = _question ->
            options = Enum.map(options, fn
              %Ash.Union{value: option, type: :ci_string} -> option
            end)
            %{id: id, prompt: prompt, options: options}
          end)
          %{type: "multiple_choice_question_group_response", id: id, title: title, prompts: prompts, questions: questions, prompt_responses: prompt_responses}
      end)

      FormViewModel.create!(%{page_transitions: page_transitions, responses: responses})
  end

  @impl true
  def handle_event("validate", params, socket) do
    form_params = Map.get(params, "form", %{})
    validated_form = AshPhoenix.Form.validate(socket.assigns.form, form_params, errors: socket.assigns.form.errors || false)
    {:noreply, assign(socket, form: validated_form)}
  end

  @impl true
  def handle_event("add-short-answer-group-response", %{"name" => name, "index" => question_index} = _params, socket) do
    {question_index, ""} = Integer.parse(question_index)

    responses_index =
      Enum.at(socket.assigns.form.forms.responses, question_index).forms.responses
      |> Enum.count()

    form = AshPhoenix.Form.add_form(socket.assigns.form, "#{name}[responses]", validate?: socket.assigns.form.errors || false)

    questions = Enum.map(Enum.at(form.data.responses, question_index).value.questions, fn %{id: id, prompt: prompt} -> %{id: id, prompt: prompt} end)

    form = Enum.reduce(questions, form, fn %{id: id, prompt: prompt}, form ->
      AshPhoenix.Form.add_form(form, "#{name}[responses][#{responses_index}][question_responses]", params: %{id: id, prompt: prompt}, validate?: socket.assigns.form.errors || false)
    end)

    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("remove-short-answer-group-response", %{"name" => name}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.remove_form(socket.assigns.form, name, validate?: socket.assigns.form.errors || false))}
  end

  @impl true
  def handle_event("submit", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: form_params) do
      {:ok, view_model} ->
        send(self(), {:transition_from_page, view_model})

        {:noreply, socket}

      {:error, form_with_error} ->
        {:noreply, assign(socket, form: form_with_error)}
    end
  end
end
