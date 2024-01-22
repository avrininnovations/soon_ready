defmodule SoonReady.QuantifyingNeeds.SurveyResponse.Api do
  use Ash.Api

  resources do
    resource SoonReady.QuantifyingNeeds.SurveyResponse.Encryption.Cipher
  end
end
