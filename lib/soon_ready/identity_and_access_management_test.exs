defmodule SoonReady.IdentityAndAccessManagementTest do
  use SoonReady.DataCase

  import Commanded.Assertions.EventAssertions

  alias SoonReady.Application
  alias SoonReady.IdentityAndAccessManagement.Events.ResearcherRegisteredV1

  test "WHEN: An administrator tries to register a researcher, THEN: A researcher" do
    params = %{
      first_name: "John",
      last_name: "Doe",
      username: "john.doe",
      password: "outatime1985",
      password_confirmation: "outatime1985",
    }
    {:ok, command} = SoonReady.IdentityAndAccessManagement.register_researcher(params)

    assert_receive_event(Application, ResearcherRegisteredV1,
      fn event -> event.researcher_id == command.researcher_id end,
      fn event ->
        {:ok, event} =
          event
          |> Map.from_struct()
          |> ResearcherRegisteredV1.decrypt()

        {:ok, user} = SoonReady.UserAuthentication.Entities.User.get(event.user_id)
        assert event.user_id == user.id
        assert command.username == user.username
        assert command.first_name == event.first_name
        assert command.last_name == event.last_name
      end
    )
  end
end
