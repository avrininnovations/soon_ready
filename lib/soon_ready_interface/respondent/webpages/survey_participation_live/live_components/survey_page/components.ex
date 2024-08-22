defmodule SoonReadyInterface.Respondent.Webpages.SurveyParticipationLive.LiveComponents.SurveyPage.Components do
  use Phoenix.Component
  import Phoenix.HTML.Form
  use PhoenixHTMLHelpers


  attr :is_wide, :boolean, default: false
  slot :title, required: true
  slot :subtitle
  slot :inner_block, required: true

  def page(assigns) do
    # TODO: Subtitle will always be passed. Find new way to filter
    ~H"""
    <div class={["py-8 lg:py-16 px-4", unless @is_wide do " mx-auto max-w-screen-md" end]}>
      <h2 class="mb-4 text-4xl tracking-tight font-extrabold text-center text-gray-900 dark:text-white">
        <%= render_slot(@title) %>
      </h2>

      <%= if @subtitle != [] do %>
        <p class="mb-8 lg:mb-16 font-light text-center text-gray-500 dark:text-gray-400 sm:text-xl">
          <%= render_slot(@subtitle) %>
        </p>
      <% end %>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :field, Phoenix.HTML.FormField, required: true

  def errors(assigns) do
    ~H"""
    <%= if @field.errors != [] do %>
      <%= for error <- @field.errors do %>
        <p class="text-rose-900 dark:text-rose-400"><%= SoonReadyInterface.CoreComponents.translate_error(error) %></p>
      <% end %>
    <% end %>
    """
  end

  attr :field, Phoenix.HTML.FormField, required: true
  attr :label, :string, required: true
  attr :options, :list, required: true

  def radio_group(assigns) do
    ~H"""
    <div>
        <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">
          <%= @label %>
        </label>
        <div class="space-y-2">
          <%= for {label, value} <- @options do %>
            <div class="flex items-center">
                <label class="text-sm font-medium text-gray-900 dark:text-gray-300">
                  <%= radio_button(@field.form, @field.field, value, class: "w-4 h-4 text-primary-600 bg-gray-100 border-gray-300 focus:ring-primary-500 dark:focus:ring-primary-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600") %>
                  <%= label %>
                </label>
            </div>
          <% end %>
        </div>
    </div>
    """
  end

  attr :field, Phoenix.HTML.FormField, required: true
  attr :label, :string, required: true
  attr :options, :list, required: true

  def checkbox_group(assigns) do
    ~H"""
    <div>
        <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">
          <%= @label %>
        </label>
        <div class="space-y-2">
          <%= for {label, value} <- @options do %>
            <div class="flex items-center">
                <label class="text-sm font-medium text-gray-900 dark:text-gray-300">

                  <input
                    id={"#{@field.id}_#{value}"}
                    type="checkbox"
                    value={value}
                    checked={@field.value && value in @field.value}
                    name={"#{@field.name}[]"}
                    class="w-4 h-4 text-primary-600 bg-gray-100 border-gray-300 focus:ring-primary-500 dark:focus:ring-primary-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
                  />


                  <%= label %>
                </label>
            </div>
          <% end %>
        </div>
    </div>
    """
  end

  attr :label, :string, required: true
  attr :field, Phoenix.HTML.FormField, required: true
  attr :rest, :global

  def textarea(assigns) do
    ~H"""
    <div>
      <p class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"><%= @label %></p>
      <%= textarea(@field.form, @field.field, Keyword.new(@rest)) %>
      <.errors field={@field} />
    </div>
    """
  end

  attr :label, :string, required: true
  attr :field, Phoenix.HTML.FormField, required: true
  attr :rest, :global

  def number_field(assigns) do
    ~H"""
    <div>
      <p class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"><%= @label %></p>
      <%= number_input(@field.form, @field.field, Keyword.new(@rest)) %>
      <.errors field={@field} />
    </div>
    """
  end

  attr :label, :string, required: true
  attr :field, Phoenix.HTML.FormField, required: true
  attr :rest, :global

  def text_field(assigns) do
    ~H"""
    <div>
    <p class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"><%= @label %></p>
    <%= text_input(@field.form, @field.field, Keyword.new(@rest)) %>
      <.errors field={@field} />
    </div>
    """
  end

  attr :placeholder, :string, required: true
  attr :field, Phoenix.HTML.FormField, required: true
  attr :rest, :global

  def text_input(assigns) do
    ~H"""
    <div>
      <%= text_input(@field.form, @field.field, [{:placeholder, @placeholder} | Keyword.new(@rest)]) %>
      <.errors field={@field} />
    </div>
    """
  end

  slot :inner_block, required: true

  def submit(assigns) do
    ~H"""
    <button name="submit"><%= render_slot(@inner_block) %></button>
    """
  end








  def rating_section(assigns) do
    ~H"""
    <div class="h-full w-full text-sm text-left text-gray-500 dark:text-gray-400">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :questions, :list, required: true


  attr :desired_outcomes, :list, required: true
  attr :importance_options, :list, required: true
  attr :satisfaction_options, :list, required: true
  slot :importance_prompt, required: true
  slot :satisfaction_prompt, required: true

  def rating_section_header(assigns) do

    # <div class="lg:col-span-3 px-4 lg:px-3 py-4 font-medium text-gray-900 dark:text-gray-200">
    # <%= render_slot(@importance_prompt) %>
    # </div>
    # <div class="lg:col-span-3 px-4 lg:px-3 py-4 font-medium text-gray-900 dark:text-gray-200">
    # <%= render_slot(@satisfaction_prompt) %>
    # </div>



    # <.header_option_labels options={@importance_options} />
    # <.header_option_labels options={@satisfaction_options} />
    ~H"""
    <div class="sticky top-0 text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">

      <%!-- TODO: Remove the assumption that there will always be 2 question columns --%>
      <div class="grid grid-cols-2 lg:grid-cols-8 px-2">
          <div class="hidden lg:block col-span-2 px-6 py-4 font-medium text-gray-900 dark:text-white">
          </div>
          <%= for question <- @questions do %>
            <div class="lg:col-span-3 px-4 lg:px-3 py-4 font-medium text-gray-900 dark:text-gray-200">
              <%= question.prompt %>
            </div>
          <% end %>
      </div>

      <div class="hidden break-words lg:grid lg:grid-cols-8 lg:gap-2 px-2 text-center border-b bg-gray-50 dark:bg-gray-800 dark:border-gray-700">
          <%!-- TODO: Remove the need for this empty div --%>
          <div class="col-span-2">
          </div>
          <%= for question <- @questions do %>
            <.header_option_labels options={question.options} />
          <% end %>
      </div>

    </div>
    """
  end

  def header_option_labels(assigns) do
    ~H"""
    <div class="col-span-3 grid grid-cols-5 px-3">
        <%= for option <- (Enum.map(@options, &atom_to_sentence_case_string/1)) do %>
            <div class="py-4">
                <%= option %>
            </div>
        <% end %>
    </div>
    """
  end

  # slot :inner_block, required: true

  def rating_section_body(assigns) do
    ~H"""
    <div>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :desired_outcome, :string, required: true
  slot :radio_group do
    attr :field, Phoenix.HTML.FormField, required: true
    attr :options, :list, required: true
  end

  def outcome_rating(assigns) do
    ~H"""
    <div class="lg:hidden border-b bg-gray-50 dark:bg-gray-800 dark:border-gray-700">
        <div class="px-6 py-4">
            <%= @desired_outcome %>
        </div>
    </div>

    <div class="grid grid-cols-2 px-2 py-2 lg:grid-cols-8 lg:gap-2 bg-white border-b dark:bg-gray-900 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">
      <div class="hidden lg:block col-span-2 px-6 py-4 font-medium text-gray-900 dark:text-white">
          <%= @desired_outcome %>
      </div>

      <%= render_slot(@inner_block) %>

      <%= for radio_group <- @radio_group do %>
      <div class="lg:col-span-3 lg:grid lg:items-center px-4 lg:px-0 py-4">
        <ul class="lg:grid lg:grid-cols-5 px-3 text-sm font-medium text-gray-900 bg-white border border-gray-200 rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white">
          <%= for option_value <- radio_group.options do %>
            <.radio_button field={radio_group.field} value={option_value} label={atom_to_sentence_case_string(option_value)} checked={radio_group.field.value == option_value} />
          <% end %>
        </ul>

        <.errors field={radio_group.field} />
        <%!-- <.error :for={msg <- Enum.map(radio_group.field.errors, &translate_error(&1))}><%= msg %></.error> --%>
      </div>

      <% end %>
    </div>
    """
  end

  attr :field, Phoenix.HTML.FormField, required: true
  attr :options, :list, required: true
  def rating_radio_group(assigns) do
    ~H"""
    <div class="lg:col-span-3 lg:grid lg:items-center px-4 lg:px-0 py-4">
      <ul class="lg:grid lg:grid-cols-5 px-3 text-sm font-medium text-gray-900 bg-white border border-gray-200 rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white">
        <%= for option_value <- @options do %>
          <.radio_button field={@field} value={option_value} label={atom_to_sentence_case_string(option_value)} checked={@field.value == option_value} />
        <% end %>
      </ul>

      <.errors field={@field} />
    </div>
    """
  end

  def radio_button(assigns) do
    ~H"""
    <li class="w-full border-b border-gray-200 rounded-t-lg dark:border-gray-600">
        <div class="flex items-center pl-3 lg:pl-0">
            <input id={"#{@field.id}_#{@value}"} type="radio" value={@value} checked={@checked} name={@field.name} class="w-4 h-4 lg:mx-auto text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-700 dark:focus:ring-offset-gray-700 focus:ring-2 dark:bg-gray-600 dark:border-gray-500">
            <label for={"#{@field.id}_#{@value}"} class="lg:hidden w-full py-3 ml-2 text-sm font-medium text-gray-900 dark:text-gray-300"><%= @label %></label>
        </div>
    </li>
    """
  end


  slot :icon
  # TODO: Improve component naming
  # TODO: Add index attr
  def accordion(assigns) do
    ~H"""
    <h2 id={"accordion-open-heading-#{@index}"}>
      <button
        type="button"
        class={"flex items-center justify-between w-full p-5 font-medium text-left border border-b-0 border-gray-200 #{if @index == 0, do: "rounded-t-xl "}focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-800 dark:border-gray-700 hover:bg-gray-100 dark:hover:bg-gray-800 bg-gray-100 dark:bg-gray-800 text-gray-900 dark:text-white"}
        data-accordion-target={"#accordion-open-body-#{@index}"}
        aria-expanded="true"
        aria-controls={"accordion-open-body-#{@index}"}
      >
        <span class="flex items-center">
          <%= render_slot(@title) %>
        </span>
        <svg
          data-accordion-icon
          class="w-6 h-6 rotate-180 shrink-0"
          fill="currentColor"
          viewBox="0 0 20 20"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            fill-rule="evenodd"
            d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
            clip-rule="evenodd"
          >
          </path>
        </svg>
      </button>
    </h2>
    <div
      id={"accordion-open-body-#{@index}"}
      aria-labelledby={"accordion-open-heading-#{@index}"}
    >
      <div class="p-5 font-light border border-gray-200 dark:border-gray-700 dark:bg-gray-900">
        <ul class="text-sm font-medium text-gray-900 bg-white border border-gray-200 rounded-lg dark:bg-gray-700 dark:border-gray-600 dark:text-white">
          <%= render_slot(@inner_block) %>
        </ul>
      </div>
    </div>
    """
  end

  def mcq_group(assigns) do
    # TODO: How do I handle index?

    # TODO: Rename ODI related component, attr and slot names
    ~H"""
    <.accordion index={@index}>
      <:title><%= @title %></:title>

      <.rating_section>
        <.rating_section_header questions={@questions} />

        <.rating_section_body>
          <.inputs_for :let={prompt_form} field={@form[:prompt_responses]}>
            <.outcome_rating desired_outcome={prompt_form.data.prompt}>
              <.inputs_for :let={question_form} field={prompt_form[:question_responses]}>
                <.rating_radio_group field={question_form[:response]} options={question_form.data.options} />
              </.inputs_for>
            </.outcome_rating>
          </.inputs_for>
        </.rating_section_body>
      </.rating_section>
    </.accordion>
    """
  end

  def short_answer_group(assigns) do
    ~H"""
    <div>
      <h3 class="block mb-2 font-medium text-gray-900 dark:text-white"><%= @group_prompt %></h3>

      <.inputs_for :let={f} field={@form[:responses]}>
        <div class="flex my-2 gap-2">
          <.inputs_for :let={ff} field={f[:question_responses]}>
            <.hidden_input field={ff[:id]} />
            <.hidden_input field={ff[:prompt]} />
            <.text_field
              field={ff[:response]}
              label={ff.source.source.attributes.prompt}
              class="block p-3 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 shadow-sm focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 dark:shadow-sm-light"
            />
          </.inputs_for>
          <.thrash_button action="remove-short-answer-group-response" name={f.name} target={@target} sr_description="Remove Response" />
        </div>
      </.inputs_for>

      <.add_button name={@form.name} index={@form.index} target={@target} action="add-short-answer-group-response" field={@form[:responses]}><%= @add_button_label %></.add_button>
    </div>
    """
  end

  attr :field, Phoenix.HTML.FormField, required: true
  attr :name, :string, required: true
  attr :index, :string, required: true
  attr :action, :string, required: true
  attr :target, :string, required: true
  slot :inner_block, required: true
  def add_button(assigns) do
    ~H"""
    <button name={@name} phx-click={@action} phx-target={@target} phx-value-name={@name} phx-value-index={@index} type="button"
      class="p-2 text-primary-600 hover:underline hover:border-primary-500 rounded-lg border border-gray-300 shadow-sm"
    >
      <%= render_slot(@inner_block) %>
    </button>
    <.errors field={@field} />
    """
  end

  attr :action, :string, required: true
  attr :name, :string, required: true
  attr :target, :string, required: true
  attr :sr_description, :string, required: true
  def thrash_button(assigns) do
    ~H"""
    <button type="button" phx-click={@action} phx-value-name={@name} phx-target={@target} class="text-primary-700 border border-primary-700 hover:bg-primary-700 hover:text-white focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm p-2.5 text-center inline-flex items-center dark:border-primary-500 dark:text-primary-500 dark:hover:text-white dark:focus:ring-primary-800 dark:hover:bg-primary-500">
      <svg class="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 7h14m-9 3v8m4-8v8M10 3h4a1 1 0 0 1 1 1v3H9V4a1 1 0 0 1 1-1ZM6 7h12v13a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1V7Z"/>
      </svg>
      <span class="sr-only"><%= @sr_description %></span>
    </button>
    """
  end

  attr :field, Phoenix.HTML.FormField, required: true
  attr :rest, :global

  def hidden_input(assigns) do
    ~H"""
    <div>
      <%= hidden_input(@field.form, @field.field, Keyword.new(@rest)) %>
    </div>
    """
  end


  defp atom_to_sentence_case_string(atom) do
    atom
    |> to_string()
    |> String.replace("_", " ")
    |> String.capitalize()
  end
end
