defmodule SoonReadyInterface.Researcher.Webpages.OdiSurveyCreationLive.Components.Form do
  use Phoenix.Component
  import Phoenix.HTML.Form

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

  attr :label, :string, required: true
  attr :field, Phoenix.HTML.FormField, required: true
  attr :rest, :global

  def text_field(assigns) do
    ~H"""
    <div>
      <p><%= @label %></p>
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

  attr :field, Phoenix.HTML.FormField, required: true

  def checkbox(assigns) do
    ~H"""
    <%= checkbox(@field.form, @field.field) %>
    """
  end

  slot :inner_block, required: true

  def submit(assigns) do
    ~H"""
    <button name="submit"><%= render_slot(@inner_block) %></button>
    """
  end

  attr :rest, :global
  def thrash_button(assigns) do
    ~H"""
    <button type="button" {@rest} class="text-primary-700 border border-primary-700 hover:bg-primary-700 hover:text-white focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm p-2.5 text-center inline-flex items-center dark:border-primary-500 dark:text-primary-500 dark:hover:text-white dark:focus:ring-primary-800 dark:hover:bg-primary-500">
      <svg class="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 7h14m-9 3v8m4-8v8M10 3h4a1 1 0 0 1 1 1v3H9V4a1 1 0 0 1 1-1ZM6 7h12v13a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1V7Z"/>
      </svg>
      <span class="sr-only"><%= render_slot(@inner_block) %></span>
    </button>
    """
  end

  slot :header, required: true
  slot :body, required: true
  def card(assigns) do
    ~H"""
    <div class="w-80 rounded-lg border border-gray-200 shadow dark:border-gray-700 dark:bg-gray-800">
      <div class="p-4 lg:p-8">
        <%= render_slot(@header) %>
      </div>
      <hr>
      <div class="p-4 lg:p-8 flex flex-col gap-2">
        <%= render_slot(@body) %>
      </div>
    </div>
    """
  end
end
