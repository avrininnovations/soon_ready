defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.ViewModels.DemographicsForm.Question do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :prompt, :string, allow_nil?: false
    attribute :options, {:array, :string}, allow_nil?: false
    # TODO: Resolve nil inconsistency
    attribute :response, :string, allow_nil?: true
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      allow_nil_input [:response]
    end
  end

  code_interface do
    define_for SoonReadyInterface.Respondents.Setup.Api

    define :create
  end
end
