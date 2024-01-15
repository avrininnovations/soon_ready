defmodule SoonReadyWeb.Respondents.Web.SurveyParticipationLive do
  use SoonReadyWeb, :live_view

  import SoonReadyWeb.Respondents.Web.SurveyParticipationLive.Components.Form
  alias SoonReadyWeb.Respondents.Web.SurveyParticipationLive.ViewModels.{
    NicknameForm,
    ScreeningForm
  }
  alias SoonReadyWeb.Respondents.ReadModels.ActiveOdiSurveys

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

      <.form :let={f} for={@screening_form} phx-submit="submit-screening-questions">
        <.inputs_for :let={ff} field={f[:questions]}>
          <Doggo.input
            field={ff[:response]}
            type="radio-group"
            label={ff.data.prompt}
            options={Enum.map(ff.data.options, fn option -> {option.value, option.value} end)}
          />
        </.inputs_for>

        <.submit>Take your Next Step</.submit>
      </.form>
    </div>
    """
  end

  def render(%{live_action: :contact_details} = assigns) do
    ~H"""
    <div>
      <h1>Contact Details</h1>
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
    {:ok, survey} = ActiveOdiSurveys.get(survey_id)
    {:ok, screening_form_view_model} = ScreeningForm.from_read_model(survey)

    socket =
      socket
      |> assign(:survey_id, survey_id)
      |> assign(:nickname_form, AshPhoenix.Form.for_create(NicknameForm, :create, api: SoonReadyWeb.Respondents.Setup.Api))
      |> assign(:screening_form, AshPhoenix.Form.for_update(screening_form_view_model, :update, api: SoonReadyWeb.Respondents.Setup.Api, forms: [
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

  def handle_event("submit-screening-questions", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.screening_form, params: form_params) do
      {:ok, view_model} ->
        if view_model.all_responses_are_correct do
          params = Map.put(socket.assigns.params, "screening_form", form_params)
          {:noreply, push_patch(socket, to: ~p"/survey/participate/#{socket.assigns.survey_id}/contact-details?#{params}")}
        else
          {:noreply, push_patch(socket, to: ~p"/survey/participate/#{socket.assigns.survey_id}/thank-you")}
        end

      {:error, form_with_error} ->
        # IO.inspect(form_with_error, label: "form_with_error")
        {:noreply, assign(socket, screening_form: form_with_error)}
    end
  end
end
