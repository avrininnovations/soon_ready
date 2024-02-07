defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive do
  use SoonReadyInterface, :live_view
  import SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.Components.Form

  require Logger

  alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.{
    NicknameForm,
    ScreeningForm,
    ContactDetailsForm,
    DemographicsForm,
    ContextForm,
    ComparisonForm,
    DesiredOutcomeRatingForm
  }
  alias SoonReadyInterface.Respondents.ReadModels.OdiSurveys

  def render(%{live_action: :landing_page} = assigns) do
    ~H"""
    <.page>
      <:title>
        Welcome to our Survey!
      </:title>
      <:subtitle>
        Buckle your belts! It'll be a great (and somewhat long) ride! 😎
      </:subtitle>

      <.live_component module={NicknameForm} id="nickname_form" />
    </.page>
    """
  end

  def render(%{live_action: :screening_questions} = assigns) do
    ~H"""
    <.page>
      <:title>
        Screening Questions
      </:title>

      <.live_component module={ScreeningForm} survey={@survey} id="screening_form" />
    </.page>
    """
  end

  def render(%{live_action: :contact_details} = assigns) do
    ~H"""
    <.page>
      <:title>
        Contact Details
      </:title>

      <.live_component module={ContactDetailsForm} survey={@survey} id="contact_details_form" />
    </.page>
    """
  end

  def render(%{live_action: :demographics} = assigns) do
    ~H"""
    <.page>
      <:title>
        Demographics
      </:title>

      <.live_component module={DemographicsForm} survey={@survey} id="demographics_form" />
    </.page>
    """
  end

  def render(%{live_action: :context} = assigns) do
    ~H"""
    <div>
      <h1>Context</h1>

      <.form :let={f} for={@context_form} phx-submit="submit-context-questions">
        <.inputs_for :let={ff} field={f[:questions]}>
          <Doggo.input
            field={ff[:response]}
            type="radio-group"
            label={ff.data.prompt}
            options={Enum.map(ff.data.options, fn option -> {option, option} end)}
          />
        </.inputs_for>

        <Doggo.button type="submit" name="submit">Proceed</Doggo.button>
      </.form>
    </div>
    """
  end

  def render(%{live_action: :comparison} = assigns) do
    ~H"""
    <div>
      <h1>Comparison</h1>

      <.form :let={f} for={@comparison_form} phx-submit="submit-comparison-questions">
        <Doggo.input
          field={f[:alternatives_used]}
          type="textarea"
          label={"What products, services or platforms have you used to #{f.data.job_to_be_done}?"}
        />
        <Doggo.input
          field={f[:additional_resources_used]}
          type="textarea"
          label="What additional things do you usually use/require when you're using any of the above?"
        />
        <Doggo.input
          field={f[:amount_spent_annually_in_naira]}
          type="number"
          label={"In total, how much would you estimate that you spend annually to #{f.data.job_to_be_done}?"}
        />
        <Doggo.input
          field={f[:is_willing_to_pay_more]}
          type="radio-group"
          label="Would you be willing to pay more for a better solution?"
          options={[{"Yes", "Yes"}, {"No", "No"}]}
        />
        <Doggo.input
          field={f[:extra_amount_willing_to_pay_in_naira]}
          type="number"
          label="If yes, how much extra would you be willing to pay annually to get the job done perfectly?"
        />

        <Doggo.button type="submit" name="submit">Proceed</Doggo.button>
      </.form>
    </div>
    """
  end

  def render(%{live_action: :desired_outcome_ratings} = assigns) do
    ~H"""
    <div>
      <h1>Desired Outcome Ratings</h1>

      <.form :let={f} for={@desired_outcome_rating_form} phx-submit="submit-desired-outcome-ratings">
        <.inputs_for :let={ff} field={f[:job_steps]}>
          <.inputs_for :let={fff} field={ff[:desired_outcomes]}>
            <Doggo.input
              field={fff[:importance]}
              type="radio-group"
              label={"When you #{ff.data.name}, how important is it to you to:"}
              options={[
                {"Not At All Important", "Not At All Important"},
                {"Somewhat Important", "Somewhat Important"},
                {"Important", "Important"},
                {"Very Important", "Very Important"},
                {"Extremely Important", "Extremely Important"},
              ]}
            />
            <Doggo.input
              field={fff[:satisfaction]}
              type="radio-group"
              label={"Given your current solutions, how are you with your ability to:"}
              options={[
                {"Not At All Satisfied", "Not At All Satisfied"},
                {"Somewhat Satisfied", "Somewhat Satisfied"},
                {"Satisfied", "Satisfied"},
                {"Very Satisfied", "Very Satisfied"},
                {"Extremely Satisfied", "Extremely Satisfied"},
              ]}
            />
          </.inputs_for>
        </.inputs_for>

        <Doggo.button type="submit" name="submit">Proceed</Doggo.button>
      </.form>
    </div>
    """
  end

  def render(%{live_action: :thank_you} = assigns) do
    ~H"""
    <div>
      <h1>Thank You!</h1>
    </div>
    """
  end

  def mount(%{"survey_id" => survey_id} = _params, _session, socket) do
    # TODO: Make asyncronous
    {:ok, survey} = OdiSurveys.get_active(survey_id)
    {:ok, screening_form_view_model} = ScreeningForm.from_read_model(survey)
    {:ok, demographics_form_view_model} = DemographicsForm.from_read_model(survey)
    {:ok, context_form_view_model} = ContextForm.from_read_model(survey)
    {:ok, comparison_form_view_model} = ComparisonForm.initialize(survey.market.job_to_be_done)
    {:ok, desired_outcome_rating_form_view_model} = DesiredOutcomeRatingForm.from_read_model(survey)

    socket =
      socket
      |> assign(:survey, survey)
      |> assign(:nickname_form, AshPhoenix.Form.for_create(NicknameForm, :create, api: SoonReadyInterface.Respondents.Setup.Api))
      |> assign(:screening_form, AshPhoenix.Form.for_update(screening_form_view_model, :update, api: SoonReadyInterface.Respondents.Setup.Api, forms: [
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
      |> assign(:contact_details_form, AshPhoenix.Form.for_create(ContactDetailsForm, :create, api: SoonReadyInterface.Respondents.Setup.Api))
      |> assign(:demographics_form, AshPhoenix.Form.for_update(demographics_form_view_model, :update, api: SoonReadyInterface.Respondents.Setup.Api, forms: [
        questions: [
          type: :list,
          data: demographics_form_view_model.questions,
          update_action: :update,
          transform_params: fn form, params, _arg3 ->
            params
            |> Map.put("prompt", form.data.prompt)
            |> Map.put("options", form.data.options)
          end
        ]
      ]))
      |> assign(:context_form, AshPhoenix.Form.for_update(context_form_view_model, :update, api: SoonReadyInterface.Respondents.Setup.Api, forms: [
        questions: [
          type: :list,
          data: context_form_view_model.questions,
          update_action: :update,
          transform_params: fn form, params, _arg3 ->
            params
            |> Map.put("prompt", form.data.prompt)
            |> Map.put("options", form.data.options)
          end
        ]
      ]))
      |> assign(:comparison_form, AshPhoenix.Form.for_update(comparison_form_view_model, :update, api: SoonReadyInterface.Respondents.Setup.Api))
      |> assign(:desired_outcome_rating_form, AshPhoenix.Form.for_update(desired_outcome_rating_form_view_model, :update, api: SoonReadyInterface.Respondents.Setup.Api, forms: [
        job_steps: [
          type: :list,
          data: desired_outcome_rating_form_view_model.job_steps,
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

  def handle_params(params, _url, socket) do
    {:noreply, assign(socket, params: params)}
  end

  def handle_info({:update_params, new_params}, socket) do
    params = Map.merge(socket.assigns.params, new_params)
    {:noreply, assign(socket, :params, params)}
  end

  def handle_info({:handle_submission, NicknameForm}, socket) do
    {:noreply, push_patch(socket, to: ~p"/survey/participate/#{socket.assigns.params["survey_id"]}/screening-questions?#{socket.assigns.params}")}
  end

  def handle_info({:handle_submission, ScreeningForm, all_responses_are_correct}, socket) do
    if all_responses_are_correct do
      {:noreply, push_patch(socket, to: ~p"/survey/participate/#{socket.assigns.params["survey_id"]}/contact-details?#{socket.assigns.params}")}
    else
      {:noreply, push_patch(socket, to: ~p"/survey/participate/#{socket.assigns.params["survey_id"]}/thank-you")}
    end
  end

  def handle_info({:handle_submission, ContactDetailsForm}, socket) do
    {:noreply, push_patch(socket, to: ~p"/survey/participate/#{socket.assigns.params["survey_id"]}/demographics?#{socket.assigns.params}")}
  end

  def handle_info({:handle_submission, DemographicsForm}, socket) do
    {:noreply, push_patch(socket, to: ~p"/survey/participate/#{socket.assigns.params["survey_id"]}/context?#{socket.assigns.params}")}
  end
  
  def handle_event("submit-context-questions", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.context_form, params: form_params) do
      {:ok, view_model} ->
        normalized_data = ContextForm.normalize(view_model)
        params = Map.put(socket.assigns.params, "context_form", normalized_data)
        {:noreply, push_patch(socket, to: ~p"/survey/participate/#{params["survey_id"]}/comparison?#{params}")}

      {:error, form_with_error} ->
        {:noreply, assign(socket, context_form: form_with_error)}
    end
  end

  def handle_event("submit-comparison-questions", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.comparison_form, params: form_params) do
      {:ok, view_model} ->
        normalized_data = ComparisonForm.normalize(view_model)
        params = Map.put(socket.assigns.params, "comparison_form", normalized_data)
        {:noreply, push_patch(socket, to: ~p"/survey/participate/#{params["survey_id"]}/desired-outcome-ratings?#{params}")}

      {:error, form_with_error} ->
        {:noreply, assign(socket, comparison_form: form_with_error)}
    end
  end

  def handle_event("submit-desired-outcome-ratings", %{"form" => form_params}, socket) do
    validated_form = AshPhoenix.Form.validate(socket.assigns.desired_outcome_rating_form, form_params)

    case AshPhoenix.Form.submit(validated_form) do
      {:ok, view_model} ->
        normalized_data = DesiredOutcomeRatingForm.normalize(view_model)
        params = Map.put(socket.assigns.params, "desired_outcome_rating_form", normalized_data)
        normalized_params = normalize(params)

        case SoonReady.QuantifyingNeeds.SurveyResponse.submit(normalized_params) do
          {:ok, _aggregate} ->
            {:noreply, push_patch(socket, to: ~p"/survey/participate/#{params["survey_id"]}/thank-you")}
          {:error, error} ->
            Logger.error("DEBUG: #{inspect(error)}")
            socket =
              socket
              |> assign(desired_outcome_rating_form: validated_form)
              |> put_flash(:error, "Something went wrong. Please try again or contact support.")
            {:noreply, socket}
        end

      {:error, form_with_error} ->
        {:noreply, assign(socket, desired_outcome_rating_form: form_with_error)}
    end
  end

  def normalize(params) do
    %{
      survey_id: params["survey_id"],
      participant: %{
        nickname: params["nickname_form"]["nickname"],
        email: params["contact_details_form"]["email"],
        phone_number: params["contact_details_form"]["phone_number"]
      },
      screening_responses: params["screening_form"],
      demographic_responses: params["demographics_form"],
      context_responses: params["context_form"],
      comparison_responses: params["comparison_form"],
      desired_outcome_ratings: params["desired_outcome_rating_form"]
    }
  end
end
