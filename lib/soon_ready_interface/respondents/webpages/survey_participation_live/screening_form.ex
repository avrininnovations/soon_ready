defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.ScreeningForm do
  use SoonReadyInterface, :live_component
  use Ash.Resource, data_layer: :embedded
  import SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.Components.Form

  alias SoonReadyInterface.Respondents.ReadModels.OdiSurveys
  alias __MODULE__.{Question, Option}

  attributes do
    attribute :questions, {:array, Question}, allow_nil?: false
  end

  calculations do
    calculate :all_responses_are_correct, :boolean, fn record, _context ->
      Enum.all?(record.questions, fn question ->
        Enum.any?(question.options, fn option ->
          option.is_correct && question.response == option.value
        end)
      end)
    end
  end

  changes do
    change load(:all_responses_are_correct)
  end

  actions do
    defaults [:create, :read, :update]

    create :from_read_model do
      argument :survey, OdiSurveys, allow_nil?: false

      change fn changeset, _context ->
        read_model = Ash.Changeset.get_argument(changeset, :survey)

        questions = Enum.map(read_model.screening_questions, fn screening_question ->
          Question.create!(%{
            prompt: screening_question.prompt,
            options: Enum.map(screening_question.options, fn option ->
              Option.create!(%{
                value: option.value,
                is_correct: option.is_correct
              })
            end)
          })
        end)
        Ash.Changeset.change_attribute(changeset, :questions, questions)
      end
    end
  end

  code_interface do
    define_for SoonReadyInterface.Respondents.Setup.Api

    define :from_read_model do
      args [:survey]
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form :let={f} for={@form} phx-change="validate" phx-submit="submit" phx-target={@myself} class="flex flex-col gap-2">
        <.inputs_for :let={ff} field={f[:questions]}>
          <.radio_group
            field={ff[:response]}
            label={ff.data.prompt}
            options={Enum.map(ff.data.options, fn option -> {option.value, option.value} end)}
          />
        </.inputs_for>

        <button type="submit" name="submit" class="mt-4 py-3 px-5 my-auto text-sm font-medium text-center text-white rounded-lg bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">Proceed</button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    socket = assign(socket, :form, AshPhoenix.Form.for_create(__MODULE__, :create, api: SoonReadyInterface.Researcher.Api))

    {:ok, screening_form_view_model} = __MODULE__.from_read_model(assigns.survey)

    socket =
      assign(socket, :form, AshPhoenix.Form.for_update(screening_form_view_model, :update, api: SoonReadyInterface.Respondents.Setup.Api, forms: [
        questions: [
          type: :list,
          data: screening_form_view_model.questions,
          update_action: :update,
          transform_params: fn form, params, _arg3 ->
            params
            |> Map.put("prompt", form.data.prompt)
            |> Map.put("options", form.data.options)
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
        send(self(), {:update_params, %{"screening_form" => normalize(view_model)}})
        send(self(), {:handle_submission, __MODULE__, view_model.all_responses_are_correct})

        {:noreply, socket}

      {:error, form_with_error} ->
        {:noreply, assign(socket, form: form_with_error)}
    end
  end

  def normalize(%{__struct__: __MODULE__, questions: questions}) do
    questions
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {question, index}, questions ->
      Map.put(questions, "#{index}", %{
        "prompt" => question.prompt,
        "response" => question.response
      })
    end)
  end
end
