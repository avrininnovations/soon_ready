defmodule SoonReady.IdentityAndAccessManagementTest do
  use SoonReady.DataCase

  import Commanded.Assertions.EventAssertions

  alias SoonReady.Application

  alias SoonReady.IdentityAndAccessManagement.Events.{
    ResearcherRegistrationInitiatedV1,
    ResearcherRegistrationSucceededV1,
  }

  test "WHEN: An administrator tries to register a researcher, THEN: A researcher" do
    params = %{
      first_name: "John",
      last_name: "Doe",
      username: "john.doe",
      password: "outatime1985",
      password_confirmation: "outatime1985",
    }
    {:ok, command} = SoonReady.IdentityAndAccessManagement.initiate_researcher_registration(params)

    assert_receive_event(Application, ResearcherRegistrationInitiatedV1,
      fn event -> event.researcher_id == command.researcher_id end,
      fn event ->
        {:ok, event} =
          event
          |> Map.from_struct()
          |> ResearcherRegistrationInitiatedV1.create()

        assert command.first_name == event.first_name
        assert command.last_name == event.last_name
        assert command.username == event.username
        assert command.password == event.password
        assert command.password_confirmation == event.password_confirmation
      end
    )

    assert_receive_event(Application, ResearcherRegistrationSucceededV1,
      fn event -> event.researcher_id == command.researcher_id end,
      fn event ->
        {:ok, event} =
          event
          |> Map.from_struct()
          |> ResearcherRegistrationSucceededV1.create()

        {:ok, user} = SoonReady.IdentityAndAccessManagement.Resources.User.get(event.user_id)
        assert event.user_id == user.id
        assert command.username == user.username
        # TODO: Test password
        # assert command.password == user.password
      end
    )
  end
end
