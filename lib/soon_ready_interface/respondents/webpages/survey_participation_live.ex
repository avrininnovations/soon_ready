defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive do
  use SoonReadyInterface, :live_view

  alias SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.ViewModels.{
    NicknameForm,
    ScreeningForm,
    ContactDetailsForm,
    DemographicsForm,
    ContextForm,
  }
  alias SoonReadyInterface.Respondents.ReadModels.ActiveOdiSurveys

  def render(%{live_action: :landing_page} = assigns) do
    ~H"""
    <div>
      <h1>Welcome to our Survey!</h1>

      <.form :let={f} for={@nickname_form} phx-submit="submit-nickname">
        <Doggo.input
          field={f[:nickname]}
          placeholder="What's your nickname?"
        />
        <Doggo.button type="submit" name="submit">Start Your Adventure</Doggo.button>
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

        <Doggo.button type="submit" name="submit">Take your Next Step</Doggo.button>
      </.form>
    </div>
    """
  end

  def render(%{live_action: :contact_details} = assigns) do
    ~H"""
    <div>
      <h1>Contact Details</h1>

      <.form :let={f} for={@contact_details_form} phx-submit="submit-contact-details">
        <Doggo.input
          field={f[:email]}
          type="email"
          placeholder="Email"
        />
        <Doggo.input
          field={f[:phone_number]}
          type="tel"
          placeholder="Phone Number"
        />
        <Doggo.button type="submit" name="submit">Proceed</Doggo.button>
      </.form>
    </div>
    """
  end

  def render(%{live_action: :demographics} = assigns) do
    ~H"""
    <div>
      <h1>Demographics</h1>

      <.form :let={f} for={@demographics_form} phx-submit="submit-demographic-questions">
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
    {:ok, demographics_form_view_model} = DemographicsForm.from_read_model(survey)
    {:ok, context_form_view_model} = ContextForm.from_read_model(survey)

    socket =
      socket
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


    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, assign(socket, params: params)}
  end

  def handle_event("submit-nickname", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.nickname_form, params: form_params) do
      {:ok, _view_model} ->
        params = Map.put(socket.assigns.params, "nickname_form", form_params)
        {:noreply, push_patch(socket, to: ~p"/survey/participate/#{params["survey_id"]}/screening-questions?#{params}")}

      {:error, form_with_error} ->
        {:noreply, assign(socket, nickname_form: form_with_error)}
    end
  end

  def handle_event("submit-screening-questions", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.screening_form, params: form_params) do
      {:ok, view_model} ->
        if view_model.all_responses_are_correct do
          params = Map.put(socket.assigns.params, "screening_form", form_params)
          {:noreply, push_patch(socket, to: ~p"/survey/participate/#{params["survey_id"]}/contact-details?#{params}")}
        else
          {:noreply, push_patch(socket, to: ~p"/survey/participate/#{socket.assigns.params["survey_id"]}/thank-you")}
        end

      {:error, form_with_error} ->
        {:noreply, assign(socket, screening_form: form_with_error)}
    end
  end

  def handle_event("submit-contact-details", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.contact_details_form, params: form_params) do
      {:ok, _view_model} ->
        params = Map.put(socket.assigns.params, "contact_details_form", form_params)
        {:noreply, push_patch(socket, to: ~p"/survey/participate/#{params["survey_id"]}/demographics?#{params}")}

      {:error, form_with_error} ->
        {:noreply, assign(socket, contact_details_form: form_with_error)}
    end
  end

  def handle_event("submit-demographic-questions", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.demographics_form, params: form_params) do
      {:ok, _view_model} ->
        params = Map.put(socket.assigns.params, "demographics_form", form_params)
        {:noreply, push_patch(socket, to: ~p"/survey/participate/#{params["survey_id"]}/context?#{params}")}

      {:error, form_with_error} ->
        {:noreply, assign(socket, demographics_form: form_with_error)}
    end
  end

  def handle_event("submit-context-questions", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.context_form, params: form_params) do
      {:ok, _view_model} ->
        params = Map.put(socket.assigns.params, "context_form", form_params)
        {:noreply, push_patch(socket, to: ~p"/survey/participate/#{params["survey_id"]}/comparison?#{params}")}

      {:error, form_with_error} ->
        {:noreply, assign(socket, context_form: form_with_error)}
    end
  end
end
