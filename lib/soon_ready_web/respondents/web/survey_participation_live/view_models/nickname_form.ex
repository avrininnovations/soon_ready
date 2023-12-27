defmodule SoonReadyWeb.Respondents.Web.SurveyParticipationLive.ViewModels.NicknameForm do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :nickname, :string, allow_nil?: false
  end
end
