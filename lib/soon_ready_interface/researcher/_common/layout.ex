defmodule SoonReadyInterface.Researcher.Common.Layout do
  use SoonReadyInterface, :html

  def layout(assigns) do
    ~H"""
    <main class="dark:text-white">
      <.flash_group flash={@flash} />
      <header>
        <nav class="bg-white border-gray-200 px-4 lg:px-6 py-4 dark:bg-gray-800">
          <div class="flex flex-wrap justify-center items-center mx-auto max-w-screen-xl">
            <a href={~p"/"} class="flex items-center">
              <span class="self-center text-xl font-semibold whitespace-nowrap dark:text-white">😎 SoonReady</span>
            </a>
          </div>
        </nav>
      </header>
      <section class="bg-white dark:bg-gray-900">
        <%= @inner_content %>
      </section>
    </main>
    """
  end

end
