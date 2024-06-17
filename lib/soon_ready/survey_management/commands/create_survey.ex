defmodule SoonReady.SurveyManagement.Commands.CreateSurvey do
  use Ash.Resource,
    # authorizers: [Ash.Policy.Authorizer],
    domain: SoonReady.SurveyManagement

  alias SoonReady.Application
  alias SoonReady.SurveyManagement.DomainConcepts.{SurveyPage, Trigger}

  # alias SoonReady.IdentityAndAccessManagement.Checks.ActorIsResearcher

  attributes do
    attribute :survey_id, :uuid, primary_key?: true, allow_nil?: false, default: &Ash.UUID.generate/0
    attribute :starting_page_id, :uuid, allow_nil?: false
    # attribute :pages, {:array, SurveyPage}, constraints: [min_length: 1]
    # attribute :raw_pages_data, {:array, :map}, constraints: [min_length: 1]
    # attribute :trigger, Trigger
  end

  # policies do
  #   policy always() do
  #     authorize_if ActorIsResearcher
  #   end
  # end


  actions do
    default_accept [
      :survey_id,
      :starting_page_id,
      # :pages,
      # :raw_pages_data,
      # :trigger,
    ]

    defaults [:create, :read]

    create :dispatch do
      # # TODO: Avoid this. I think it's even causing a bug where pages without titles are accepted
      # argument :pages, {:array, :map}, allow_nil?: false

      # change fn changeset, context ->
      #   pages = Ash.Changeset.get_argument(changeset, :pages)

      #   changeset =
      #     changeset
      #     |> Ash.Changeset.change_attribute(:pages, pages)
      #     |> Ash.Changeset.change_attribute(:raw_pages_data, pages)
      # end

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
    define :dispatch
    define :create
  end
end
