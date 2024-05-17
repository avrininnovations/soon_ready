defmodule SoonReady.SurveyManagement.Commands.CreateSurvey do
  use Ash.Resource,
    # authorizers: [Ash.Policy.Authorizer],
    data_layer: :embedded

  alias SoonReady.Application
  alias SoonReady.SurveyManagement.DomainObjects.{SurveyPage, Trigger}

  # alias SoonReady.IdentityAndAccessManagement.Checks.ActorIsResearcher

  attributes do
    uuid_primary_key :survey_id
    attribute :pages, {:array, SurveyPage}, constraints: [min_length: 1]
    attribute :trigger, Trigger
  end

  # policies do
  #   policy always() do
  #     authorize_if ActorIsResearcher
  #   end
  # end


  actions do
    defaults [:create, :read]

    create :dispatch do
      change fn changeset, context ->
        Ash.Changeset.after_action(changeset, fn changeset, command ->
          with :ok <- Application.dispatch(command) do
            {:ok, command}
          end
        end)
      end
    end
  end

  code_interface do
    define_for SoonReady.SurveyManagement
    define :dispatch
    define :create
  end
end
