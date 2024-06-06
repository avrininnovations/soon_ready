defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel do
  use SoonReadyInterface, :live_component
  use Ash.Resource, data_layer: :embedded
  import SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.Components.Form
  import SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.Components.Layout


  alias SoonReady.SurveyManagement.DomainObjects.{
    SurveyPage,
    Transition,
    ShortAnswerQuestion,
    MultipleChoiceQuestion,
    OptionWithCorrectFlag,
    ParagraphQuestion,
    MultipleChoiceQuestionGroup,
  }

  alias SoonReady.SurveyManagement.DomainObjects.Transition.{Always, ResponseEquals, AnyTrue, AllTrue}
  alias __MODULE__.Question

  attributes do
    attribute :page, SurveyPage, allow_nil?: false
    attribute :questions, {:array, Question}, allow_nil?: false
  end

  def transition_condition_fulfilled(_resource, %{type: Always}) do
    true
  end

  def transition_condition_fulfilled(%{questions: questions} = _resource, %{type: ResponseEquals, value: %{question_id: question_id, value: value}}) do
    Enum.any?(questions, fn question -> question.value.id == question_id && to_string(question.value.response) == to_string(value) end)
  end

  def transition_condition_fulfilled(resource, %{type: AnyTrue, value: %{conditions: conditions}}) do
    Enum.any?(conditions, fn condition -> transition_condition_fulfilled(resource, condition) end)
  end

  def transition_condition_fulfilled(resource, %{type: AllTrue, value: %{conditions: conditions}}) do
    Enum.all?(conditions, fn condition -> transition_condition_fulfilled(resource, condition) end)
  end

  calculations do
    calculate :transition, Transition, fn resource, _context ->
      transition = Enum.find(resource.page.transitions, fn transition -> transition_condition_fulfilled(resource, transition.condition) end)
      {:ok, transition}
    end
  end

  actions do
    defaults [:create, :read, :update]

    update :submit do
      change load(:transition)
    end
  end

  code_interface do
    define_for SoonReadyInterface.Respondents.Setup.Api
    define :create
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form :let={f} for={@form} phx-change="validate" phx-submit="submit" phx-target={@myself} class="flex flex-col gap-2">
        <.inputs_for :let={ff} field={f[:questions]}>
          <%= case ff.data.value.type do %>
            <% __MODULE__.ShortAnswerQuestion -> %>
              <.text_field
                field={ff[:response]}
                label={ff.data.value.value.prompt}
                class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
              />
            <% __MODULE__.MultipleChoiceQuestion -> %>
              <.radio_group
                field={ff[:response]}
                label={ff.data.value.value.prompt}
                options={Enum.map(ff.data.value.value.options, fn option -> {option, option} end)}
              />
            <% __MODULE__.ParagraphQuestion -> %>
              <.textarea
                field={ff[:response]}
                label={ff.data.value.value.prompt}
                class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
              />
            <% __MODULE__.MultipleChoiceQuestionGroup -> %>
              <.mcq_group
                form={ff}
                index={ff.index}
                title={ff.data.value.value.title}
                questions={ff.data.value.value.questions}
              />
          <% end %>
        </.inputs_for>

        <button type="submit" name="submit" class="mt-4 py-3 px-5 my-auto text-sm font-medium text-center text-white rounded-lg bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">Proceed</button>
      </.form>
    </div>
    """
  end

  def mcq_group(assigns) do


    # <.inputs_for :let={job_step_form} field={f[:job_steps]}>
    #   <.accordion index={job_step_form.index}>
    #   ...
    # </.inputs_for>

    # TODO: Where should the accordion_section be? Wrapping the entire page?
    # TODO: How do I handle index?




  #   <.rating_section_header importance_options={@importance_values} satisfaction_options={@satisfaction_values}>
  #   <:importance_prompt>When you <%= job_step_form.data.name %>, how important is it to you to:</:importance_prompt>
  #   <:satisfaction_prompt>Given the solutions you currently have, how satisfied are you with your ability to:</:satisfaction_prompt>
  # </.rating_section_header>

  # <.rating_section_body>
  #   <.inputs_for :let={desired_outcome_form} field={job_step_form[:desired_outcomes]}>
  #     <.outcome_rating desired_outcome={desired_outcome_form.data.name}>
  #       <:radio_group field={desired_outcome_form[:importance]} options={@importance_values} />
  #       <:radio_group field={desired_outcome_form[:satisfaction]} options={@satisfaction_values} />
  #     </.outcome_rating>
  #   </.inputs_for>
  # </.rating_section_body>


  # <.rating_section_body>
  #     <.inputs_for :let={prompt_form} field={@form[:prompt_responses]}>
  #       <.outcome_rating desired_outcome={prompt_form.data.prompt.prompt}>
  #         <.inputs_for :let={question_form} field={@prompt_form[:question_responses]}>
  #           <:radio_group field={question_form[:response]} options={question_form.data.question.options} />
  #         </.inputs_for>
  #       </.outcome_rating>
  #     </.inputs_for>
  #   </.rating_section_body>
  # </.rating_section>

  # <:radio_group field={question_form[:response]} options={question_form.data.question.options} />



    # TODO: Rename ODI related component, attr and slot names
    ~H"""
    <.accordion_section>
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
    </.accordion_section>
    """
  end

  def create_response_view_model(%{questions: questions} = page) do

    questions =
      questions
      |> Enum.map(fn
        %Ash.Union{type: ShortAnswerQuestion, value: %ShortAnswerQuestion{id: id, prompt: prompt}} ->
          %{type: "short_answer_question", id: id, prompt: prompt}
        %Ash.Union{type: MultipleChoiceQuestion, value: %MultipleChoiceQuestion{id: id, prompt: prompt, options: options}} ->
          options = Enum.map(options, fn
            %Ash.Union{type: OptionWithCorrectFlag, value: %OptionWithCorrectFlag{value: value}} ->
              value
            %Ash.Union{type: :ci_string, value: value} ->
              value
          end)
          %{type: "multiple_choice_question", id: id, prompt: prompt, options: options}
        %Ash.Union{type: ParagraphQuestion, value: %ParagraphQuestion{id: id, prompt: prompt}} ->
          %{type: "paragraph_question", id: id, prompt: prompt}
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
          %{type: "multiple_choice_question_group", id: id, title: title, prompts: prompts, questions: questions, prompt_responses: prompt_responses}
          |> IO.inspect(label: "MCQ INSPECT")

      end)

      __MODULE__.create!(%{page: page, questions: questions})
  end

  @impl true
  def update(assigns, socket) do
    view_model =
      assigns.current_page
      |> create_response_view_model()

    socket =
      socket
      |> assign(:current_page, assigns.current_page)
      |> assign(:form, AshPhoenix.Form.for_update(view_model, :submit, api: SoonReadyInterface.Respondents.Setup.Api, forms: [
        questions: [
          type: :list,
          data: view_model.questions,
          update_action: :update,
          forms: [
            prompt_responses: [
              type: :list,
              data: fn
                %AshPhoenix.Form.WrappedValue{value: %{type: __MODULE__.MultipleChoiceQuestionGroup}} = question -> question.value.value.prompt_responses
                _question -> []
              end,
              update_action: :update,
              forms: [
                question_responses: [
                  type: :list,
                  data: fn prompt_response -> prompt_response.question_responses end,
                  update_action: :update,
                ]
              ],
            ]
          ],
          transform_params: fn form, params, _arg3 ->
            case form.data.value do
              %Ash.Union{type: __MODULE__.ShortAnswerQuestion, value: %{id: id, prompt: prompt}} ->
                params
                |> Map.put("type", "short_answer_question")
                |> Map.put("id", id)
                |> Map.put("prompt", prompt)
              %Ash.Union{type: __MODULE__.MultipleChoiceQuestion, value: %{id: id, prompt: prompt, options: options}} ->
                params
                |> Map.put("type", "short_answer_question")
                |> Map.put("id", id)
                |> Map.put("prompt", prompt)
                |> Map.put("options", options)
              %Ash.Union{type: __MODULE__.ParagraphQuestion, value: %{id: id, prompt: prompt}} ->
                params
                |> Map.put("type", "paragraph_question")
                |> Map.put("id", id)
                |> Map.put("prompt", prompt)
              %Ash.Union{type: __MODULE__.MultipleChoiceQuestionGroup, value: %{id: id, title: title, prompts: prompts, questions: questions}} ->
                params
                |> Map.put("type", "multiple_choice_question_group")
                |> Map.put("id", id)
                |> Map.put("title", title)
                |> Map.put("prompts", prompts)
                |> Map.put("questions", questions)
            end
            # # TODO: Response/Responses fields that are not used
          end
        ]
      ]))

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", params, socket) do
    form_params = Map.get(params, "form", %{})
    validated_form = AshPhoenix.Form.validate(socket.assigns.form, form_params, errors: socket.assigns.form.errors || false)
    {:noreply, assign(socket, form: validated_form)}
  end

  @impl true
  def handle_event("submit", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: form_params) do
      {:ok, view_model} ->
        # TODO: Rename message
        send(self(), {:update_params, view_model})

        {:noreply, socket}

      {:error, form_with_error} ->
        {:noreply, assign(socket, form: form_with_error)}
    end
  end

  def normalize(%{__struct__: __MODULE__, page: %{id: page_id}, questions: questions}) do
    questions =
      questions
      |> Enum.reduce(%{}, fn %{id: question_id} = question, questions ->
        Map.put(questions, question_id, %{
          "response" => question.response
        })
      end)

    %{"pages" => %{page_id => %{"questions" => questions}}}
  end
end
