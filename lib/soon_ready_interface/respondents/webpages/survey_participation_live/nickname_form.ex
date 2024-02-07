defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLive.NicknameForm do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :nickname, :string, allow_nil?: false
  end

  def normalize(%{__struct__: __MODULE__, nickname: nickname}) do
    %{"nickname" => nickname}
  end
end
