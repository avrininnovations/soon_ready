defmodule SoonReady.Onboarding.UseCases do
  def join_waitlist(email) do
    # {:error, :some_other_error}
    {:ok, %{email: email}}
  end
end
