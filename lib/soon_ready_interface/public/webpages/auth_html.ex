defmodule SoonReadyInterface.Public.Webpages.AuthHtml do
  use SoonReadyInterface, :html

  def home(assigns) do
    ~H"""
    <nav class="bg-gray-800">
      <div class="px-2 mx-auto max-w-7xl sm:px-6 lg:px-8">
        <div class="relative flex items-center justify-between h-16">
          <div
            class="flex items-center justify-center flex-1 sm:items-stretch sm:justify-start"
          >
            <div class="block ml-6">
              <div class="flex space-x-4">
                <div class="px-3 py-2 text-xl font-medium text-white ">
                  Ash Demo
                </div>
              </div>
            </div>
          </div>
          <div
            class="absolute inset-y-0 right-0 flex items-center pr-2 sm:static sm:inset-auto sm:ml-6 sm:pr-0"
          >
            <%= if @current_user do %>
            <span class="px-3 py-2 text-sm font-medium text-white rounded-md">
              <%= @current_user.email %>
            </span>
            <a
              href="/sign-out"
              class="rounded-lg bg-zinc-100 px-2 py-1 text-[0.8125rem] font-semibold leading-6 text-zinc-900 hover:bg-zinc-200/80 active:text-zinc-900/70"
            >
              Sign out
            </a>
            <% else %>
            <a
              href="/sign-in"
              class="rounded-lg bg-zinc-100 px-2 py-1 text-[0.8125rem] font-semibold leading-6 text-zinc-900 hover:bg-zinc-200/80 active:text-zinc-900/70"
            >
              Sign In
            </a>
            <% end %>
          </div>
        </div>
      </div>
    </nav>

    <div class="py-10">
      <header>
        <div class="px-4 mx-auto max-w-7xl sm:px-6 lg:px-8">
          <h1 class="text-3xl font-bold leading-tight tracking-tight text-gray-900">
            Demo
          </h1>
        </div>
      </header>
      <main>
        <div class="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div class="px-4 py-8 sm:px-0">
            <div
              class="border-4 border-gray-200 border-dashed rounded-lg h-96"
            ></div>
          </div>
        </div>
      </main>
    </div>
    """
  end

  def failure(assigns) do
    ~H"""
    <h1 class="text-2xl">Authentication Error</h1>
    """
  end
end
