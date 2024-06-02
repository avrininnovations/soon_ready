defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel do
  use SoonReadyInterface, :live_component
  use Ash.Resource, data_layer: :embedded
  import SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.Components.Form

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
    Enum.any?(questions, fn question -> question.id == question_id && to_string(question.response) == to_string(value) end)
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
          <%= case ff.data.type do %>
            <% ShortAnswerQuestion -> %>
              <.text_field
                field={ff[:response]}
                label={ff.data.prompt}
                class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
              />
            <% MultipleChoiceQuestion -> %>
              <.radio_group
                field={ff[:response]}
                label={ff.data.prompt}
                options={Enum.map(ff.data.options, fn option -> {option, option} end)}
              />
            <% ParagraphQuestion -> %>
              <.textarea
                field={ff[:response]}
                label={ff.data.prompt}
                class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
              />
          <% end %>
        </.inputs_for>

        <button type="submit" name="submit" class="mt-4 py-3 px-5 my-auto text-sm font-medium text-center text-white rounded-lg bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">Proceed</button>
      </.form>
    </div>
    """
  end

  def create_response_view_model(%{questions: questions} = page) do
    questions =
      questions
      |> Enum.map(fn
        %Ash.Union{type: ShortAnswerQuestion, value: %ShortAnswerQuestion{id: id, prompt: prompt}} ->
          %{type: ShortAnswerQuestion, id: id, prompt: prompt}
        %Ash.Union{type: MultipleChoiceQuestion, value: %MultipleChoiceQuestion{id: id, prompt: prompt, options: options}} ->
          options = Enum.map(options, fn
            %Ash.Union{type: OptionWithCorrectFlag, value: %OptionWithCorrectFlag{value: value}} ->
              value
            %Ash.Union{type: :ci_string, value: value} ->
              value
          end)
          %{type: MultipleChoiceQuestion, id: id, prompt: prompt, options: options}
        %Ash.Union{type: ParagraphQuestion, value: %ParagraphQuestion{id: id, prompt: prompt}} ->
          %{type: ParagraphQuestion, id: id, prompt: prompt}
        %Ash.Union{type: MultipleChoiceQuestionGroup, value: %MultipleChoiceQuestionGroup{id: id, prompts: prompts, questions: questions}} ->
          prompts = Enum.map(prompts, fn %{prompt: prompt} -> prompt end)
          IO.inspect(questions)
          %{type: MultipleChoiceQuestionGroup, id: id, prompts: prompts, questions: questions}

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
          transform_params: fn form, params, _arg3 ->
            params
            |> Map.put("id", form.data.id)
            |> Map.put("type", form.data.type)
            |> Map.put("prompt", form.data.prompt)
            |> Map.put("options", form.data.options)
            # TODO: Response/Responses fields that are not used
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
