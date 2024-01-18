defmodule SoonReady.Vault do
  use Cloak.Vault, otp_app: :soon_ready

  # WARNING: The chosen tag gets embedded in the encrypted text
  # This means that if you change the tag, you will not be able to decrypt the text
  # This is a feature of the Cloak library

  def init(config) do
    config =
      Keyword.put(config, :ciphers, [
        {SoonReady.QuantifyNeeds.SurveyResponse.Encryption.Cipher, {
          SoonReady.QuantifyNeeds.SurveyResponse.Encryption.Cipher,
          tag: "#{SoonReady.QuantifyNeeds.SurveyResponse.Encryption.Cipher}"
        }},
        {:onboarding, {
          SoonReady.Onboarding.PersonallyIdentifiableInformation.Cipher,
          tag: "Onboarding",
        }},
        # {SoonReady.QuantifyNeeds.SurveyResponse.Encryption.Cipher, {
        #   SoonReady.QuantifyNeeds.SurveyResponse.Encryption.Cipher,
        #   tag: "#{SoonReady.QuantifyNeeds.SurveyResponse.Encryption.Cipher}"
        # }}
      ])

    {:ok, config}
  end
end
