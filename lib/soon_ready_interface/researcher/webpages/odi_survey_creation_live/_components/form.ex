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
end
