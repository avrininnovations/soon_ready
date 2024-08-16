defmodule SoonReady.SurveyManagement do
  use Ash.Domain

  resources do
    # Domain Events
    resource SoonReady.SurveyManagement.V1.DomainEvents.SurveyCreated
    resource SoonReady.SurveyManagement.V1.DomainEvents.SurveyPublished
    resource SoonReady.SurveyManagement.V1.DomainEvents.SurveyResponseSubmitted

    # Integration Events
    resource SoonReady.SurveyManagement.V1.IntegrationEvents.SurveyPublished
  end

  authorization do
    authorize :by_default
  end
end
