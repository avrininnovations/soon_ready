defmodule SoonReady.SurveyManagement.Commands.CreateSurvey do
  use Ash.Resource,
    # authorizers: [Ash.Policy.Authorizer],
    data_layer: :embedded

  alias SoonReady.Application
  alias SoonReady.SurveyManagement.DomainObjects.{SurveyPage, Trigger}

  # alias SoonReady.IdentityAndAccessManagement.Checks.ActorIsResearcher

  attributes do
    attribute :survey_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :starting_page_id, :uuid, allow_nil?: false
    attribute :pages, {:array, SurveyPage}, constraints: [min_length: 1]
    attribute :raw_pages_data, {:array, :map}, constraints: [min_length: 1]
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
      # TODO: Avoid this. I think it's even causing a bug where pages without titles are accepted
      argument :pages, {:array, :map}, allow_nil?: false

      change fn changeset, context ->
        pages = Ash.Changeset.get_argument(changeset, :pages)

        changeset =
          changeset
          |> Ash.Changeset.change_attribute(:pages, pages)
          |> Ash.Changeset.change_attribute(:raw_pages_data, pages)

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
