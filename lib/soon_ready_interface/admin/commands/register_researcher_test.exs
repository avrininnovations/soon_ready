defmodule SoonReadyInterface.Admin.Commands.RegisterResearcherTest do
  use SoonReady.DataCase
  import Commanded.Assertions.EventAssertions

  alias SoonReady.IdentityAndAccessManagement.V1.Events.ResearcherRegistered

  test "WHEN: An Admin tries to register a reseacher, THEN: A researcher is registered" do
    {:ok, command} = SoonReadyInterface.Admin.register_researcher(%{
      first_name: "First",
      last_name: "Last",
      username: "username",
      password: "password",
      password_confirmation: "password"
    })

    assert_receive_event(SoonReady.Application, ResearcherRegistered,
      fn event -> event.researcher_id == command.researcher_id end,
      fn event ->
        {:ok, event} = ResearcherRegistered.decrypt(event)

        assert event.first_name == command.first_name
        assert event.last_name == command.last_name
        assert event.username == command.username
        assert event.password == command.password
        assert event.password_confirmation == command.password_confirmation
      end
    )
  end
end
