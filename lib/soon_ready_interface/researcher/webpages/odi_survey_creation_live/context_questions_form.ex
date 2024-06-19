# defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.ContextQuestionsForm do
#   use SoonReadyInterface, :live_component
#   use Ash.Resource, data_layer: :embedded
#   import SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Components.Form

#   alias __MODULE__.ContextQuestionField

#   attributes do
#     attribute :context_questions, {:array, ContextQuestionField}, allow_nil?: false
#   end

#   @impl true
#   def render(assigns) do
#     ~H"""
#     <div>
#       <.card_form :let={f} for={@form} phx-change="validate" phx-submit="submit" target={@myself}>
#         <.inputs_for :let={ff} field={f[:context_questions]}>
#           <.card>
#             <:header>
#               <.card_header>
#                 <:title>Prompt</:title>
#                 <:thrash_button click="remove-context-question" name={"#{ff.name}"} target={@myself}>Remove Context Question</:thrash_button>
#                 <:text_input field={ff[:prompt]} placeholder="Enter prompt" />
#               </.card_header>
#             </:header>
#             <:body>
#               <.inputs_for :let={fff} field={ff[:options]}>
#                 <.card_field>
#                   <:text_input field={fff[:value]} placeholder="Option" />
#                   <:thrash_button click="remove-context-question-option" name={"#{fff.name}"} target={@myself}>Remove Context Question Option</:thrash_button>
#                 </.card_field>
#               </.inputs_for>
#             </:body>
#             <:add_button name={ff.name} action="add-context-question-option" target={@myself} field={ff[:options]}> Add option </:add_button>
#           </.card>
#         </.inputs_for>

#         <:add_button action="add-context-question" form_field={:context_questions}> Add context question </:add_button>
#         <:submit>Proceed</:submit>
#       </.card_form>
#     </div>
#     """
#   end

#   @impl true
#   def update(_assigns, socket) do
#     socket = assign(socket, :form, AshPhoenix.Form.for_create(__MODULE__, :create, domain: SoonReadyInterface.Researcher.Domain, forms: [auto?: true]))

#     {:ok, socket}
#   end

#   @impl true
#   def handle_event("validate", params, socket) do
#     form_params = Map.get(params, "form", %{})
#     validated_form = AshPhoenix.Form.validate(socket.assigns.form, form_params, errors: socket.assigns.form.errors || false)
#     {:noreply, assign(socket, form: validated_form)}
#   end

#   @impl true
#   def handle_event("submit", params, socket) do
#     form_params = Map.get(params, "form", %{})
#     case AshPhoenix.Form.submit(socket.assigns.form, params: form_params) do
#       {:ok, _view_model} ->
#         send(self(), {:update_params, %{"context_questions_form" => form_params}})
#         send(self(), {:handle_submission, __MODULE__})

#         {:noreply, socket}

#       {:error, form_with_error} ->
#         {:noreply, assign(socket, form: form_with_error)}
#     end
#   end

#   @impl true
#   def handle_event("add-context-question", _params, socket) do
#     {:noreply, assign(socket, form: AshPhoenix.Form.add_form(socket.assigns.form, :context_questions, validate?: socket.assigns.form.errors || false))}
#   end

#   @impl true
#   def handle_event("add-context-question-option", %{"name" => name} = _params, socket) do
#     {:noreply, assign(socket, form: AshPhoenix.Form.add_form(socket.assigns.form, "#{name}[options]", validate?: socket.assigns.form.errors || false))}
#   end

#   @impl true
#   def handle_event("remove-context-question", %{"name" => name}, socket) do
#     {:noreply, assign(socket, form: AshPhoenix.Form.remove_form(socket.assigns.form, name, validate?: socket.assigns.form.errors || false))}
#   end

#   @impl true
#   def handle_event("remove-context-question-option", %{"name" => name}, socket) do
#     {:noreply, assign(socket, form: AshPhoenix.Form.remove_form(socket.assigns.form, name, validate?: socket.assigns.form.errors || false))}
#   end
# end
