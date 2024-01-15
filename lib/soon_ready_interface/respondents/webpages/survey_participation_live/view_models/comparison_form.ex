defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.ViewModels.ComparisonForm do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :job_to_be_done, :string, allow_nil?: false
    attribute :alternatives_used, :string
    attribute :additional_resources_used, :string
    attribute :amount_spent_annually_in_naira, :string
    # TODO: Change to Enum?
    attribute :is_willing_to_pay_more, :string
    attribute :extra_amount_willing_to_pay_in_naira, :string
  end

  actions do
    create :initialize
  end

  code_interface do
    define_for SoonReadyInterface.Respondents.Setup.Api

    define :initialize do
      args [:job_to_be_done]
    end
  end
end
