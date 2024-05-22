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


  alias SoonReady.SurveyManagement.DomainObjects.ShortAnswerQuestion
  alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.FormViewModel
  alias SoonReady.SurveyManagement.DomainObjects.PageAction.ChangePage

  def render(assigns) do
    # <.live_component module={NicknameForm} id="nickname_form" />
    ~H"""
    <.page>
      <:title>
        <%= @current_page.title %>
      </:title>
      <:subtitle>
        <%= @current_page.description %>
      </:subtitle>

      <.live_component module={FormViewModel} current_page={@current_page} id="form_view_model" />
    </.page>
    """
  end

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

  def get_page(%{pages: pages} = _survey, page_id) do
    pages
    |> Enum.filter(fn %{id: id} = _page -> page_id == id end)
    |> Enum.at(0)
  end

  def create_response_view_model(%{questions: questions} = page) do
    questions =
      questions
      |> Enum.map(fn
        %Ash.Union{type: ShortAnswerQuestion, value: %ShortAnswerQuestion{id: id, prompt: prompt}} -> %{type: ShortAnswerQuestion, id: id, prompt: prompt}
      end)
    FormViewModel.create!(%{page: page, questions: questions})
  end

  def mount(%{"survey_id" => survey_id} = _params, _session, socket) do
    # TODO: Make asyncronous
    {:ok, %{starting_page_id: starting_page_id} = survey} = Survey.get_active(survey_id)

    {:ok, assign(socket, :survey, survey)}
  end

  def handle_params(params, url, %{assigns: %{survey: survey}} = socket) do
    case Map.get(params, "page_id") do
      nil ->
        # TODO: Handle bad page id. redirect/flash
        current_page = get_page(survey, survey.starting_page_id)

        socket =
          socket
          |> push_patch(to: ~p"/survey/participate/#{params["survey_id"]}/pages/#{current_page.id}")
          |> assign(params: params, current_page: current_page)

        {:noreply, socket}
      page_id ->
        current_page = get_page(survey, page_id)

        {:noreply, assign(socket, params: params, current_page: current_page)}
    end
  end

  # TODO: Change message name
  def handle_info({:update_params, view_model}, socket) do
    params =
      view_model
      |> normalize_view_model()
      |> Map.merge(socket.assigns.params)

    case view_model do
      %{next_action: %Ash.Union{value: %ChangePage{destination_page_id: next_page_id}}} ->
        socket =
          socket
          |> assign(:params, params)
          |> push_patch(to: ~p"/survey/participate/#{socket.assigns.params["survey_id"]}/pages/#{next_page_id}?#{params}")

        {:noreply, socket}
      # TODO: Submit
    end
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

  def normalize_view_model(%{__struct__: FormViewModel, page: %{id: page_id}, questions: questions}) do
    questions =
      questions
      |> Enum.reduce(%{}, fn %{id: question_id} = question, questions ->
        Map.put(questions, question_id, %{
          "response" => question.response
        })
      end)
    %{"pages" => %{page_id => %{"questions" => questions}}}
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
