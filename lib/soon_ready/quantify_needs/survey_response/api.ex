defmodule SoonReady.QuantifyNeeds.SurveyResponse.Api do
  use Ash.Api

  resources do
    resource SoonReady.QuantifyNeeds.SurveyResponse.Encryption.Cipher
  end
end
