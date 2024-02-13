defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.ComparisonForm do
  use SoonReadyInterface, :live_component
  use Ash.Resource, data_layer: :embedded
  import SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.Components.Form

  attributes do
    attribute :job_to_be_done, :string, allow_nil?: false
    attribute :alternatives_used, :string
    attribute :additional_resources_used, :string
    attribute :amount_spent_annually_in_naira, :string
    # TODO: Change to Enum?
    attribute :is_willing_to_pay_more, :string
    attribute :extra_amount_willing_to_pay_in_naira, :string
  end

  actions do
    create :initialize do
      change fn changeset, context ->
        Ash.Changeset.change_attribute(changeset, :job_to_be_done, String.downcase(changeset.attributes.job_to_be_done))
      end
    end
  end

  code_interface do
    define_for SoonReadyInterface.Respondents.Setup.Api

    define :initialize do
      args [:job_to_be_done]
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form :let={f} for={@form} phx-change="validate" phx-submit="submit" phx-target={@myself} class="flex flex-col gap-6">
        <.textarea
          field={f[:alternatives_used]}
          label={"What products, services or platforms have you used to #{f.data.job_to_be_done}?"}
          class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
        />
        <.textarea
          field={f[:additional_resources_used]}
          label="What additional things do you usually use/require when you're using any of the above?"
          class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
        />
        <.number_field
          field={f[:amount_spent_annually_in_naira]}
          label={"In total, how much would you estimate that you spend annually to #{f.data.job_to_be_done}?"}
          class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
        />
        <.radio_group
          field={f[:is_willing_to_pay_more]}
          label="Would you be willing to pay more for a better solution?"
          options={[{"Yes", "Yes"}, {"No", "No"}]}
        />
        <.number_field
          field={f[:extra_amount_willing_to_pay_in_naira]}
          label="If yes, how much extra would you be willing to pay annually to get the job done perfectly?"
          class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
        />

        <button type="submit" name="submit" class="mt-4 py-3 px-5 my-auto text-sm font-medium text-center text-white rounded-lg bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">Proceed</button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, view_model} = __MODULE__.initialize(assigns.survey.market.job_to_be_done)

    socket = assign(socket, :form, AshPhoenix.Form.for_update(view_model, :update, api: SoonReadyInterface.Respondents.Setup.Api))

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
        send(self(), {:update_params, %{"comparison_form" => normalize(view_model)}})
        send(self(), {:handle_submission, __MODULE__})

        {:noreply, socket}

      {:error, form_with_error} ->
        {:noreply, assign(socket, form: form_with_error)}
    end
  end

  def normalize(%{__struct__: __MODULE__, job_to_be_done: job_to_be_done, alternatives_used: alternatives_used, additional_resources_used: additional_resources_used, amount_spent_annually_in_naira: amount_spent_annually_in_naira, is_willing_to_pay_more: is_willing_to_pay_more, extra_amount_willing_to_pay_in_naira: extra_amount_willing_to_pay_in_naira}) do
    %{
      "0" => %{"prompt" => "What products, services or platforms have you used to #{job_to_be_done}?", "response" => alternatives_used},
      "1" => %{"prompt" => "What additional things do you usually use/require when you're using any of the above?", "response" => additional_resources_used},
      "2" => %{"prompt" => "In total, how much would you estimate that you spend annually to #{job_to_be_done}?", "response" => amount_spent_annually_in_naira},
      "3" => %{"prompt" => "Would you be willing to pay more for a better solution?", "response" => is_willing_to_pay_more},
      "4" => %{"prompt" => "If yes, how much extra would you be willing to pay annually to get the job done perfectly?", "response" => extra_amount_willing_to_pay_in_naira}
    }
  end
end
