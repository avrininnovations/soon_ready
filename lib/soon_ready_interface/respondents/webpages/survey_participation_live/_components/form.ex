defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.Components.Form do
  use Phoenix.Component
  import Phoenix.HTML.Form


  attr :is_wide, :boolean, default: false
  slot :title, required: true
  slot :subtitle
  slot :inner_block, required: true

  def page(assigns) do
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

  slot :inner_block, required: true

  def submit(assigns) do
    ~H"""
    <button name="submit"><%= render_slot(@inner_block) %></button>
    """
  end
end
