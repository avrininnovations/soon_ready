defmodule SoonReadyInterface.Admin do
  use Ash.Domain, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    # Commands
    resource SoonReadyInterface.Admin.Commands.RegisterResearcher do
      define :initiate_researcher_registration, action: :dispatch
    end

    # Command Handlers
    resource SoonReadyInterface.Admin.Commands.Handler
  end
end
