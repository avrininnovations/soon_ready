defmodule SoonReadyInterface.Router do
  use SoonReadyInterface, :router
  use AshAuthentication.Phoenix.Router

  import AshAdmin.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SoonReadyInterface.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
  end

  scope "/", SoonReadyInterface.Public.Webpages do
    pipe_through :browser

    sign_in_route(register_path: "/register", reset_path: "/reset")
    sign_out_route AuthController
    auth_routes_for SoonReady.UserAuthentication.Entities.User, to: AuthController
    reset_route []
  end

  scope "/", SoonReadyInterface.Public.Webpages do
    pipe_through :browser

    live "/", HomepageLive, :home
  end

  ash_authentication_live_session :researcher_session do
    scope "/", SoonReadyInterface.Researcher.Webpages do
      pipe_through :browser

      live "/odi-survey/create/context-questions", OdiSurveyCreationLive, :context_questions
      live "/odi-survey/create/demographic-questions", OdiSurveyCreationLive, :demographic_questions
      live "/odi-survey/create/screening-questions", OdiSurveyCreationLive, :screening_questions
      live "/odi-survey/create/desired-outcomes", OdiSurveyCreationLive, :desired_outcomes
      live "/odi-survey/create/market-definition", OdiSurveyCreationLive, :market_definition
      live "/odi-survey/create", OdiSurveyCreationLive, :landing_page
    end
  end

  scope "/", SoonReadyInterface.Respondents.Webpages do
    pipe_through :browser

    live "/survey/participate/:survey_id", SurveyParticipationLive, :landing_page
    live "/survey/participate/:survey_id/screening-questions", SurveyParticipationLive, :screening_questions
    live "/survey/participate/:survey_id/contact-details", SurveyParticipationLive, :contact_details
    live "/survey/participate/:survey_id/demographics", SurveyParticipationLive, :demographics
    live "/survey/participate/:survey_id/context", SurveyParticipationLive, :context
    live "/survey/participate/:survey_id/comparison", SurveyParticipationLive, :comparison
    live "/survey/participate/:survey_id/desired-outcome-ratings", SurveyParticipationLive, :desired_outcome_ratings
    live "/survey/participate/:survey_id/thank-you", SurveyParticipationLive, :thank_you
  end

  scope "/" do
    # Pipe it through your browser pipeline
    pipe_through [:browser]

    ash_admin "/admin"
  end


  # Other scopes may use custom stacks.
  # scope "/api", SoonReadyInterface do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:soon_ready, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SoonReadyInterface.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
