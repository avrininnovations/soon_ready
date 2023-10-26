defmodule SoonReadyWeb.Public.Web.HomepageLive do
  use SoonReadyWeb, :live_view

  def local_header(assigns) do
    ~H"""
    <header>
      <nav class="bg-white border-gray-200 px-4 lg:px-6 py-4 dark:bg-gray-800">
        <div class="flex flex-wrap justify-center items-center mx-auto max-w-screen-xl">
          <a href={~p"/"} class="flex items-center">
            <span class="self-center text-xl font-semibold whitespace-nowrap dark:text-white">😎 SoonReady</span>
          </a>
        </div>
      </nav>
    </header>
    """
  end

  def hero(assigns) do
    ~H"""
    <section class="px-4 lg:px-16 text-center lg:text-left">
      <div class="grid max-w-screen-xl px-4 py-8 mx-auto lg:gap-12 xl:gap-0 lg:py-16 lg:grid-cols-12">
        <div class="mr-auto place-self-center lg:col-span-7 xl:col-span-8">
          <h1 class="max-w-2xl mb-4 text-4xl font-extrabold tracking-tight leading-none md:text-5xl xl:text-6xl dark:text-white">
            One software company at a time...
          </h1>
          <p class="max-w-2xl mb-6 font-light text-gray-500 lg:mb-8 md:text-lg lg:text-xl dark:text-gray-400">
            SoonReady is home for innovators who are trying to start successful software companies. Join other innovators on our waitlist.
          </p>
          <form action="#" class="">
            <div class="flex flex-wrap lg:flex-nowrap items-center mb-3">
              <div class="relative w-full lg:w-auto mb-3 lg:mb-0 lg:mr-3">
                <label for="member_email" class="hidden mb-2 text-sm font-medium text-gray-900 dark:text-gray-300">Email address</label>
                <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                    <svg class="w-5 h-5 text-gray-500 dark:text-gray-400" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z"></path><path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z"></path></svg>
                </div>
                <input class="block md:w-96 w-full p-3 pl-10 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 text-center lg:text-left" placeholder="Provide your email to get updates" type="email" name="member[email]" id="member_email" required="">
              </div>
              <div class="w-full lg:w-auto">
                <input type="submit" value="Join our waitlist" class="w-full px-5 py-3 text-sm font-medium text-center text-white rounded-lg cursor-pointer bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:ring-primary-300 dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800" name="member_submit" id="member_submit">
              </div>
            </div>
          </form>
        </div>
        <div class="hidden lg:mt-0 lg:col-span-5 xl:col-span-4 lg:flex">
          <img src="https://flowbite.s3.amazonaws.com/blocks/marketing-ui/hero/mobile-app.svg" alt="phone illustration">
        </div>
      </div>
    </section>
    """
  end

  def render(assigns) do
    ~H"""
    <.local_header />
    <.hero />
    """
  end
end
