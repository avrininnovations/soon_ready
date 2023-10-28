defmodule SoonReady.Onboarding.PersonallyIdentifiableInformation.EncryptionDetails do

  def get(%{person_id: person_id}) do
    {:ok, %{cloak_key: "Y/tty5KdmwYC1PoY+i7Fp18umZhYfDRw8DjcFrMFDVg="}}
  end
end
