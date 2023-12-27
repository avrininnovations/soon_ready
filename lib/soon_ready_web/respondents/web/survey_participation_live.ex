defmodule SoonReadyWeb.Respondents.Web.SurveyParticipationLive do
  use SoonReadyWeb, :live_view

  import SoonReadyWeb.Respondents.Web.SurveyParticipationLive.Components.Form
  alias SoonReadyWeb.Respondents.Web.SurveyParticipationLive.ViewModels.NicknameForm

  def render(%{live_action: :landing_page} = assigns) do
    ~H"""
    <div>
      <h1>Welcome to our Survey!</h1>

      <.form :let={f} for={@nickname_form} phx-submit="submit-nickname">
        <.text_input
          field={f[:nickname]}
          placeholder="What's your nickname?"
        />
        <.submit>Start Your Adventure</.submit>
      </.form>
    </div>
    """
  end

  def render(%{live_action: :screening_questions} = assigns) do
    ~H"""
    <div>
      <h1>Screening Questions</h1>
    </div>
    """
  end

  def mount(%{"survey_id" => survey_id} = _params, _session, socket) do
    socket =
      socket
      |> assign(:survey_id, survey_id)
      |> assign(:nickname_form, AshPhoenix.Form.for_create(NicknameForm, :create, api: SoonReadyWeb.Respondents.Setup.Api))

    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, assign(socket, params: params)}
  end

  def handle_event("submit-nickname", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.nickname_form, params: form_params) do
      {:ok, _view_model} ->
        params = Map.put(socket.assigns.params, "nickname_form", form_params)
        {:noreply, push_patch(socket, to: ~p"/survey/participate/#{socket.assigns.survey_id}/screening-questions?#{params}")}

      {:error, form_with_error} ->
        {:noreply, assign(socket, nickname_form: form_with_error)}
    end
  end
end
