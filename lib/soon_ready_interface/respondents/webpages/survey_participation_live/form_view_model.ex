defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel do
  use SoonReadyInterface, :live_component
  use Ash.Resource, data_layer: :embedded
  import SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.Components.Form

  alias SoonReady.SurveyManagement.DomainObjects.{SurveyPage, PageAction, ShortAnswerQuestion, MultipleChoiceQuestion, OptionWithCorrectFlag}

  alias __MODULE__.Question

  attributes do
    attribute :page, SurveyPage, allow_nil?: false
    attribute :questions, {:array, Question}, allow_nil?: false
  end

  calculations do
    calculate :next_action, PageAction, fn resource, _context ->
      # TODO: Actually calculate
      {:ok, resource.page.actions.correct_response_action}
    end
  end

  actions do
    defaults [:create, :read, :update]

    update :submit do
      change load(:next_action)
    end
  end

  code_interface do
    define_for SoonReadyInterface.Respondents.Setup.Api
    define :create
  end

  @impl true
  def render(assigns) do
          # <.radio_group
          #   field={ff[:response]}
          #   label={ff.data.prompt}
          #   options={Enum.map(ff.data.options, fn option -> {option, option} end)}
          # />
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
            %Ash.Union{value: %OptionWithCorrectFlag{value: value}} ->
              value
          end)

          %{type: MultipleChoiceQuestion, id: id, prompt: prompt, options: options}
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
        # TODO: No need for separate messages anymore
        # IO.inspect(view_model, label: "View Model")
        # send(self(), {:update_params, normalize(view_model)})
        send(self(), {:update_params, view_model})
        # send(self(), {:handle_submission, __MODULE__})

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
