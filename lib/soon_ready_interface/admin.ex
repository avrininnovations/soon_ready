defmodule SoonReadyInterface.Admin do
  use Ash.Domain, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    # Commands
    resource SoonReadyInterface.Admin.Commands.RegisterResearcher do
      define :register_researcher, action: :dispatch
    end

    # Command Handlers
    resource SoonReadyInterface.Admin.Commands.Aggregate
  end
end
