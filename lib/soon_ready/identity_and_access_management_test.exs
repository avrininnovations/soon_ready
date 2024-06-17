defmodule SoonReady.IdentityAndAccessManagementTest do
  use SoonReady.DataCase

  import Commanded.Assertions.EventAssertions

  alias SoonReady.Application

  alias SoonReady.IdentityAndAccessManagement.Events.{
    ResearcherRegistrationInitiatedV1,
    ResearcherRegistrationSucceededV1,
  }

  alias SoonReady.Encryption.Resources.PersonalIdentifiableInformationEncryptionKey

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
          |> ResearcherRegistrationInitiatedV1.decrypt()

        with {:ok, %{key: encryption_key} = _user_encryption_key} <- PersonalIdentifiableInformationEncryptionKey.get(event.researcher_id),
              {:ok, first_name} <- SoonReady.Vault.decrypt(%{key: encryption_key, cipher_text: event.first_name_hash}),
              {:ok, last_name} <- SoonReady.Vault.decrypt(%{key: encryption_key, cipher_text: event.last_name_hash}),
              {:ok, username} <- SoonReady.Vault.decrypt(%{key: encryption_key, cipher_text: event.username_hash}),
              {:ok, password} <- SoonReady.Vault.decrypt(%{key: encryption_key, cipher_text: event.password_hash}),
              {:ok, password_confirmation} <- SoonReady.Vault.decrypt(%{key: encryption_key, cipher_text: event.password_confirmation_hash})
        do
          assert command.first_name == event.first_name
          assert command.last_name == event.last_name
          assert command.username == event.username
          assert command.password == event.password
          assert command.password_confirmation == event.password_confirmation
        else
          error -> flunk("An error occured #{error}")
        end
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
