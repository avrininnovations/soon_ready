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
  alias SoonReadyInterface.Respondents.ReadModels.Survey

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
    <.page>
      <:title>
        Context
      </:title>

      <.live_component module={ContextForm} survey={@survey} id="context_form" />
    </.page>
    """
  end

  def render(%{live_action: :comparison} = assigns) do
    ~H"""
    <.page>
      <:title>
        Comparison
      </:title>

      <.live_component module={ComparisonForm} survey={@survey} id="comparison_form" />
    </.page>
    """
  end

  def render(%{live_action: :desired_outcome_ratings} = assigns) do
    ~H"""
    <.page is_wide={true}>
      <:title>
        Desired Outcome Ratings
      </:title>

      <.live_component module={DesiredOutcomeRatingForm} survey={@survey} id="desired_outcome_rating_form" />
    </.page>
    """
  end

  def render(%{live_action: :thank_you} = assigns) do
    ~H"""
    <.page>
      <:title>
        Thank You!
      </:title>
      <:subtitle>
        We appreciate your input to our journey! 💯🚀
      </:subtitle>
    </.page>
    """
  end

  def mount(%{"survey_id" => survey_id} = _params, _session, socket) do
    # TODO: Make asyncronous
    {:ok, survey} = Survey.get_active(survey_id)
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

  def handle_info({:handle_submission, ContextForm}, socket) do
    {:noreply, push_patch(socket, to: ~p"/survey/participate/#{socket.assigns.params["survey_id"]}/comparison?#{socket.assigns.params}")}
  end

  def handle_info({:handle_submission, ComparisonForm}, socket) do
    {:noreply, push_patch(socket, to: ~p"/survey/participate/#{socket.assigns.params["survey_id"]}/desired-outcome-ratings?#{socket.assigns.params}")}
  end

  def handle_info({:handle_submission, DesiredOutcomeRatingForm}, socket) do
    socket.assigns.params
    |> normalize()
    |> SoonReady.OutcomeDrivenInnovation.submit_response()
    |> case do
      {:ok, _aggregate} ->
        socket =
          socket
          |> put_flash(:info, "Thank you for participating in our survey!")
          |> push_patch(to: ~p"/survey/participate/#{socket.assigns.params["survey_id"]}/thank-you")
        {:noreply, socket}
      {:error, error} ->
        Logger.error("DEBUG: #{inspect(error)}")
        socket = put_flash(socket, :error, "Something went wrong. Please try again or contact support.")
        {:noreply, socket}
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
