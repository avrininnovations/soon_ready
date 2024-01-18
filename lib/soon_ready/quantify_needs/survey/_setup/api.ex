defmodule SoonReady.SurveyManagement.Setup.Api do
  use Ash.Api

  resources do
    registry SoonReady.SurveyManagement.Setup.Registry
  end
end
