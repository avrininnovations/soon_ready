defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.DesiredOutcomeRatingForm do
  use SoonReadyInterface, :live_component
  use Ash.Resource, data_layer: :embedded
  import SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.Components.Form
  import SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.Components.Layout

  alias SoonReadyInterface.Respondents.ReadModels.OdiSurveys
  alias __MODULE__.{JobStep, DesiredOutcome}

  attributes do
    attribute :job_steps, {:array, JobStep}, allow_nil?: false
  end

  actions do
    defaults [:create, :read, :update]

    create :from_read_model do
      argument :survey, OdiSurveys, allow_nil?: false

      change fn changeset, _context ->
        read_model = Ash.Changeset.get_argument(changeset, :survey)

        job_steps = Enum.map(read_model.job_steps, fn job_step ->
          JobStep.create!(%{
            name: job_step.name,
            desired_outcomes: Enum.map(job_step.desired_outcomes, fn desired_outcome ->
              DesiredOutcome.create!(%{
                name: desired_outcome
              })
            end)
          })
        end)
        Ash.Changeset.change_attribute(changeset, :job_steps, job_steps)
      end
    end
  end

  code_interface do
    define_for SoonReadyInterface.Respondents.Setup.Api

    define :from_read_model do
      args [:survey]
    end
  end

  @importance_values [
    "Not At All Important",
    "Somewhat Important",
    "Important",
    "Very Important",
    "Extremely Important"
  ]

  @satisfaction_values [
    "Not At All Satisfied",
    "Somewhat Satisfied",
    "Satisfied",
    "Very Satisfied",
    "Extremely Satisfied"
  ]

  @impl true
  def render(assigns) do
    assigns =
      assigns
      |> assign(:importance_values, @importance_values)
      |> assign(:satisfaction_values, @satisfaction_values)
    ~H"""
    <div>
      <.form :let={f} for={@form} phx-change="validate" phx-submit="submit" phx-target={@myself}>
        <.accordion_section>
          <.inputs_for :let={job_step_form} field={f[:job_steps]}>
            <.accordion index={job_step_form.index}>
              <:title>Step <%= job_step_form.index %>: <%= job_step_form.data.name %></:title>

              <.rating_section>
                <.rating_section_header importance_options={@importance_values} satisfaction_options={@satisfaction_values}>
                  <:importance_prompt>When you <%= job_step_form.data.name %>, how important is it to you to:</:importance_prompt>
                  <:satisfaction_prompt>Given the solutions you currently have, how satisfied are you with your ability to:</:satisfaction_prompt>
                </.rating_section_header>

                <.rating_section_body>
                  <.inputs_for :let={desired_outcome_form} field={job_step_form[:desired_outcomes]}>
                    <.outcome_rating desired_outcome={desired_outcome_form.data.name}>
                      <:radio_group field={desired_outcome_form[:importance]} options={@importance_values} />
                      <:radio_group field={desired_outcome_form[:satisfaction]} options={@satisfaction_values} />
                    </.outcome_rating>
                  </.inputs_for>
                </.rating_section_body>
              </.rating_section>

            </.accordion>
          </.inputs_for>
        </.accordion_section>

        <button type="submit" name="submit" class="mt-4 py-3 px-5 my-auto w-full text-sm font-medium text-center text-white rounded-lg bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">Proceed</button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, view_model} = __MODULE__.from_read_model(assigns.survey)

    socket =
      assign(socket, :form, AshPhoenix.Form.for_update(view_model, :update, api: SoonReadyInterface.Respondents.Setup.Api, forms: [
        job_steps: [
          type: :list,
          data: view_model.job_steps,
          update_action: :update,
          transform_params: fn form, params, _arg3 -> Map.put(params, "name", form.data.name) end,
          forms: [
            desired_outcomes: [
              type: :list,
              data: fn job_step -> job_step.desired_outcomes end,
              update_action: :update,
              transform_params: fn form, params, _arg3 -> Map.put(params, "name", form.data.name) end
            ]
          ]
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
        send(self(), {:update_params, %{"desired_outcome_rating_form" => normalize(view_model)}})
        send(self(), {:handle_submission, __MODULE__})

        {:noreply, socket}

      {:error, form_with_error} ->
        {:noreply, assign(socket, form: form_with_error)}
    end
  end

  def normalize(%{__struct__: __MODULE__, job_steps: job_steps}) do
    job_steps
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {job_step, index}, job_steps ->
      Map.put(job_steps, "#{index}", %{
        "name" => job_step.name,
        "desired_outcomes" =>
          job_step.desired_outcomes
          |> Enum.with_index()
          |> Enum.reduce(%{}, fn {desired_outcome, index}, desired_outcomes ->
            Map.put(desired_outcomes, "#{index}", %{
              "name" => desired_outcome.name,
              "importance" => desired_outcome.importance,
              "satisfaction" => desired_outcome.satisfaction
            })
          end)
      })
    end)
  end
end
