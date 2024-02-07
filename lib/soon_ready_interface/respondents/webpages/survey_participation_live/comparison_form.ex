defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.ComparisonForm do
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
    create :initialize do
      change fn changeset, context ->
        Ash.Changeset.change_attribute(changeset, :job_to_be_done, String.downcase(changeset.attributes.job_to_be_done))
      end
    end
  end

  code_interface do
    define_for SoonReadyInterface.Respondents.Setup.Api

    define :initialize do
      args [:job_to_be_done]
    end
  end

  def normalize(%{__struct__: __MODULE__, job_to_be_done: job_to_be_done, alternatives_used: alternatives_used, additional_resources_used: additional_resources_used, amount_spent_annually_in_naira: amount_spent_annually_in_naira, is_willing_to_pay_more: is_willing_to_pay_more, extra_amount_willing_to_pay_in_naira: extra_amount_willing_to_pay_in_naira}) do
    %{
      "0" => %{"prompt" => "What products, services or platforms have you used to #{job_to_be_done}?", "response" => alternatives_used},
      "1" => %{"prompt" => "What additional things do you usually use/require when you're using any of the above?", "response" => additional_resources_used},
      "2" => %{"prompt" => "In total, how much would you estimate that you spend annually to #{job_to_be_done}?", "response" => amount_spent_annually_in_naira},
      "3" => %{"prompt" => "Would you be willing to pay more for a better solution?", "response" => is_willing_to_pay_more},
      "4" => %{"prompt" => "If yes, how much extra would you be willing to pay annually to get the job done perfectly?", "response" => extra_amount_willing_to_pay_in_naira}
    }
  end
end
