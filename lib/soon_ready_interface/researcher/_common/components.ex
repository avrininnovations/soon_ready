defmodule SoonReadyInterface.Researcher.Common.Components do
  use SoonReadyInterface, :html

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

end
