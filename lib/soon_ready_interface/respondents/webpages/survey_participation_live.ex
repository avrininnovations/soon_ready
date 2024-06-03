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

      <%= if @current_page.questions do %>
        <.live_component module={FormViewModel} current_page={@current_page} id="form_view_model" />
      <% end %>
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

  # def create_response_view_model(%{questions: questions} = page) do
  #   questions =
  #     questions
  #     |> Enum.map(fn
  #       %Ash.Union{type: ShortAnswerQuestion, value: %ShortAnswerQuestion{id: id, prompt: prompt}} -> %{type: ShortAnswerQuestion, id: id, prompt: prompt}
  #     end)
  #   FormViewModel.create!(%{page: page, questions: questions})
  # end

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

  # TODO: Avoid collision
  defp deep_merge(map1, map2) do
    Map.merge(map1, map2, fn _key, submap1, submap2 -> deep_merge(submap1, submap2) end)
  end

  # TODO: Change message name
  def handle_info({:update_params, view_model}, socket) do
    socket.assigns.params

    params =
      view_model
      |> normalize_view_model()
      |> deep_merge(socket.assigns.params)

    # TODO: Handle submission
    %{destination_page_id: destination_page_id, submit_form?: submit_form?} = view_model.transition

    if submit_form? do
      socket.assigns.params
      |> normalize(socket.assigns.survey)
      |> SoonReady.SurveyManagement.submit_response()
      # |> IO.inspect()
      |> case do
        {:ok, _aggregate} ->
          socket =
            socket
            |> put_flash(:info, "Thank you for participating in our survey!")
            |> push_patch(to: ~p"/survey/participate/#{socket.assigns.params["survey_id"]}/pages/#{destination_page_id}")

            {:noreply, socket}
        {:error, error} ->
          Logger.error("DEBUG: #{inspect(error)}")
          socket = put_flash(socket, :error, "Something went wrong. Please try again or contact support.")
          {:noreply, socket}
      end
    else
      socket =
        socket
        |> assign(:params, params)
        |> push_patch(to: ~p"/survey/participate/#{socket.assigns.params["survey_id"]}/pages/#{destination_page_id}?#{params}")

      {:noreply, socket}
    end

  end

  def normalize_view_model(%{__struct__: FormViewModel, page: %{id: page_id}, questions: questions}) do
    questions =
      questions
      # |> IO.inspect()
      |> Enum.reduce(%{}, fn
        %{type: FormViewModel.ShortAnswerQuestion, value: %{id: question_id, response: response}} = question, questions ->
          Map.put(questions, question_id, %{
            "response" => response
          })
      end)
    %{"pages" => %{page_id => %{"questions" => questions}}}
  end

  def normalize(params, survey) do
    questions =
      Enum.reduce(survey.pages, [], fn
        %{questions: nil}, acc ->
          acc
        %{questions: questions}, acc ->
          Enum.reduce(questions, acc, fn %Ash.Union{value: question} = _question, acc ->
            [question | acc]
          end)
      end)

    responses =
      Enum.reduce(params["pages"], [], fn {_page_id, %{"questions" => page_questions}}, acc ->
        Enum.reduce(page_questions, acc, fn {question_id, response}, acc ->
          question = Enum.find(questions, fn question -> question.id == question_id end)

          response =
            case question do
              %ShortAnswerQuestion{} ->
                response =
                  response
                  |> Map.put("question_id", question_id)
                  |> Map.put("type", "short_answer_question_response")
            end
          [response | acc]
        end)
      end)

    %{"survey_id" => params["survey_id"], "responses" => responses}
  end
end
