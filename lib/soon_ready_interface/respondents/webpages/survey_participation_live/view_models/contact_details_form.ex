defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.ViewModels.ContactDetailsForm do
  use Ash.Resource, data_layer: :embedded

  attributes do
    # TODO: Create a custom type for email and phone number
    attribute :email, :string, allow_nil?: false
    attribute :phone_number, :string, allow_nil?: false
  end
end
