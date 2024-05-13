defmodule SoonReadyInterface.Respondents.Webpages.SurveyParticipationLiveTest do
  use SoonReadyInterface.ConnCase
  import Phoenix.LiveViewTest

  @survey_params %{
    brand: "A Big Brand",
    market: %{
      job_executor: "Persons",
      job_to_be_done: "Do what persons do"
    },
    job_steps: [
      %{name: "Job Step 1", desired_outcomes: [
        "Minimize the time it takes to do A",
        "Minimize the likelihood that B occurs"
      ]},
      %{name: "Job Step 2", desired_outcomes: [
        "Minimize the time it takes to do C",
        "Minimize the likelihood that D occurs"
      ]},
    ],
    screening_questions: [
      %{prompt: "What is the answer to screening question 1?", options: [
        %{value: "Option 1", is_correct: true},
        %{value: "Option 2", is_correct: false},
      ]},
      %{prompt: "What is the answer to screening question 2?", options: [
        %{value: "Option 1", is_correct: true},
        %{value: "Option 2", is_correct: false},
      ]}
    ],
    demographic_questions: [
      %{prompt: "What is the answer to demographic question 1?", options: ["Option 1", "Option 2"]},
      %{prompt: "What is the answer to demographic question 2?", options: ["Option 1", "Option 2"]}
    ],
    context_questions: [
      %{prompt: "What is the answer to context question 1?", options: ["Option 1", "Option 2"]},
      %{prompt: "What is the answer to context question 2?", options: ["Option 1", "Option 2"]}
    ]
  }

  @desired_outcome_form_params %{
    "job_steps" => %{
      "0" => %{
        "desired_outcomes" => %{
          "0" => %{"importance" => "Very Important", "satisfaction" => "Very Satisfied"},
          "1" => %{"importance" => "Somewhat Important", "satisfaction" => "Satisfied"},
        }
      },
      "1" => %{
        "desired_outcomes" => %{
          "0" => %{"importance" => "Not At All Important", "satisfaction" => "Extremely Satisfied"},
          "1" => %{"importance" => "Important", "satisfaction" => "Somewhat Satisfied"},
        }
      },
    }
  }

  @comparison_form_params %{
    alternatives_used: "Product 1, Service 2, Platform 3",
    additional_resources_used: "Thing 1, Thing 2",
    amount_spent_annually_in_naira: "1000",
    is_willing_to_pay_more: "Yes",
    extra_amount_willing_to_pay_in_naira: "1000",
  }

  @comparison_page_query_params %{
    "0" => %{"prompt" => "What products, services or platforms have you used to do what persons do?", "response" => "Product 1, Service 2, Platform 3"},
    "1" => %{"prompt" => "What additional things do you usually use/require when you're using any of the above?", "response" => "Thing 1, Thing 2"},
    "2" => %{"prompt" => "In total, how much would you estimate that you spend annually to do what persons do?", "response" => "1000"},
    "3" => %{"prompt" => "Would you be willing to pay more for a better solution?", "response" => "Yes"},
    "4" => %{"prompt" => "If yes, how much extra would you be willing to pay annually to get the job done perfectly?", "response" => "1000"}
  }

  @context_form_params %{
    "questions" => %{
      "0" => %{"response" => "Option 1"},
      "1" => %{"response" => "Option 1"}
    }
  }

  @context_page_query_params %{
    "0" => %{"prompt" => "What is the answer to context question 1?", "response" => "Option 1"},
    "1" => %{"prompt" => "What is the answer to context question 2?", "response" => "Option 1"}
  }

  @demographics_form_params %{
    "questions" => %{
      "0" => %{"response" => "Option 1"},
      "1" => %{"response" => "Option 1"}
    }
  }

  @demographics_page_query_params %{
    "0" => %{"prompt" => "What is the answer to demographic question 1?", "response" => "Option 1"},
    "1" => %{"prompt" => "What is the answer to demographic question 2?", "response" => "Option 1"}
  }

  @contact_details_form_params %{
    email: "hello@example.com",
    phone_number: "1234567890",
  }

  @contact_details_page_query_params %{
    "email" => "hello@example.com",
    "phone_number" => "1234567890"
  }

  @correct_screening_form_params %{
    "questions" => %{
      "0" => %{"response" => "Option 1"},
      "1" => %{"response" => "Option 1"}
    }
  }

  @incorrect_screening_form_params %{
    "questions" => %{
      "0" => %{"response" => "Option 1"},
      "1" => %{"response" => "Option 2"}
    }
  }

  @screening_page_query_params %{
    "0" => %{"prompt" => "What is the answer to screening question 1?", "response" => "Option 1"},
    "1" => %{"prompt" => "What is the answer to screening question 2?", "response" => "Option 1"}
  }

  @nickname_form_params %{
    nickname: "A Nickname"
  }

  @landing_page_query_params %{"nickname" => "A Nickname"}

  def submit_desired_outcome_rating_form_response(view, params \\ @desired_outcome_form_params) do
    view
    |> form("form", form: params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def submit_comparison_form_response(view, params \\ @comparison_form_params) do
    view
    |> form("form", form: params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def assert_comparison_page_query_params(path) do
    %{query: query} = URI.parse(path)
    %{"comparison_form" => query_params} = Plug.Conn.Query.decode(query)
    assert query_params == @comparison_page_query_params
  end

  def submit_context_form_response(view, params \\ @context_form_params) do
    view
    |> form("form", form: params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def assert_context_page_query_params(path) do
    %{query: query} = URI.parse(path)
    %{"context_form" => query_params} = Plug.Conn.Query.decode(query)
    assert query_params == @context_page_query_params
  end

  def submit_demographics_form_response(view, params \\ @demographics_form_params) do
    view
    |> form("form", form: params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def assert_demographics_page_query_params(path) do
    %{query: query} = URI.parse(path)
    %{"demographics_form" => query_params} = Plug.Conn.Query.decode(query)
    assert query_params == @demographics_page_query_params
  end

  def submit_contact_details_form_response(view, params \\ @contact_details_form_params) do
    view
    |> form("form", form: params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def assert_contact_details_page_query_params(path) do
    %{query: query} = URI.parse(path)
    %{"contact_details_form" => query_params} = Plug.Conn.Query.decode(query)
    assert query_params == @contact_details_page_query_params
  end

  def submit_screening_form_response(view, params \\ @correct_screening_form_params) do
    view
    |> form("form", form: params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def assert_screening_page_query_params(path) do
    %{query: query} = URI.parse(path)
    %{"screening_form" => query_params} = Plug.Conn.Query.decode(query)
    assert query_params == @screening_page_query_params
  end

  def submit_nickname_form_response(view, params \\ @nickname_form_params) do
    view
    |> form("form", form: params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def assert_landing_page_query_params(path) do
    %{query: query} = URI.parse(path)
    %{"nickname_form" => query_params} = Plug.Conn.Query.decode(query)
    assert query_params == @landing_page_query_params
  end

  setup do
    params = %{
      first_name: "John",
      last_name: "Doe",
      username: "john.doe",
      password: "outatime1985",
      password_confirmation: "outatime1985",
    }
    {:ok, %{researcher_id: researcher_id} = command} = SoonReady.IdentityAndAccessManagement.initiate_researcher_registration(params)
    {:ok, %{user: user}} = SoonReady.IdentityAndAccessManagement.get_researcher(researcher_id)

    {:ok, %{survey_id: survey_id}} = SoonReady.OutcomeDrivenInnovation.create_survey(@survey_params, user)
    {:ok, _survey} = SoonReady.OutcomeDrivenInnovation.publish_survey(%{survey_id: survey_id})

    %{survey_id: survey_id}
  end

  describe "Landing Page" do
    test "WHEN: Respondent tries to visit the survey participation url, THEN: The landing page is displayed", %{conn: conn, survey_id: survey_id} do
      {:ok, _view, html} = live(conn, ~p"/survey/participate/#{survey_id}")

      assert html =~ "Welcome to our Survey!"
    end

    test "GIVEN: Respondent has visited the survey participation url, WHEN: Respondent tries to submit a nickname, THEN: The screening questions page is displayed", %{conn: conn, survey_id: survey_id} do
      {:ok, view, _html} = live(conn, ~p"/survey/participate/#{survey_id}")

      _resulting_html = submit_nickname_form_response(view)

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{survey_id}/screening-questions"
      assert has_element?(view, "h2", "Screening Questions")
      assert_landing_page_query_params(path)
    end
  end

  describe "Screening Questions Form" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to respond correctly to the screening questions, THEN: The contact details page is displayed", %{conn: conn, survey_id: survey_id} do
      {:ok, view, _html} = live(conn, ~p"/survey/participate/#{survey_id}")
      _ = submit_nickname_form_response(view)
      _ = assert_patch(view)

      _resulting_html = submit_screening_form_response(view, @correct_screening_form_params)

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{survey_id}/contact-details"
      assert has_element?(view, "h2", "Contact Details")
      assert_screening_page_query_params(path)
    end

    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to respond incorrectly to the screening questions, THEN: The thank you page is displayed", %{conn: conn, survey_id: survey_id} do
      {:ok, view, _html} = live(conn, ~p"/survey/participate/#{survey_id}")
      _ = submit_nickname_form_response(view)
      _ = assert_patch(view)

      _resulting_html = submit_screening_form_response(view, @incorrect_screening_form_params)

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{survey_id}/thank-you"
      assert has_element?(view, "h2", "Thank You!")
    end
  end

  describe "Contact Details Form" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to submit their contact details, THEN: The demographics page is displayed", %{conn: conn, survey_id: survey_id} do
      {:ok, view, _html} = live(conn, ~p"/survey/participate/#{survey_id}")
      _ = submit_nickname_form_response(view)
      _ = assert_patch(view)
      _ = submit_screening_form_response(view)
      _ = assert_patch(view)

      _resulting_html = submit_contact_details_form_response(view)

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{survey_id}/demographics"
      assert has_element?(view, "h2", "Demographics")
      assert_contact_details_page_query_params(path)
    end
  end

  describe "Demographics Form" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to submit their demographic details, THEN: The context page is displayed", %{conn: conn, survey_id: survey_id} do
      {:ok, view, _html} = live(conn, ~p"/survey/participate/#{survey_id}")
      _ = submit_nickname_form_response(view)
      _ = assert_patch(view)
      _ = submit_screening_form_response(view)
      _ = assert_patch(view)
      _ = submit_contact_details_form_response(view)
      _ = assert_patch(view)

      _resulting_html = submit_demographics_form_response(view, @demographics_form_params)

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{survey_id}/context"
      assert has_element?(view, "h2", "Context")
      assert_demographics_page_query_params(path)
    end
  end

  describe "Context Form" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to submit their context details, THEN: The comparison page is displayed", %{conn: conn, survey_id: survey_id} do
      {:ok, view, _html} = live(conn, ~p"/survey/participate/#{survey_id}")
      _ = submit_nickname_form_response(view)
      _ = assert_patch(view)
      _ = submit_screening_form_response(view)
      _ = assert_patch(view)
      _ = submit_contact_details_form_response(view)
      _ = assert_patch(view)
      _ = submit_demographics_form_response(view)
      _ = assert_patch(view)

      _resulting_html = submit_context_form_response(view, @context_form_params)

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{survey_id}/comparison"
      assert has_element?(view, "h2", "Comparison")
      assert_context_page_query_params(path)
    end
  end

  describe "Comparison Form" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to submit their comparison details, THEN: The desired outcome rating page is displayed", %{conn: conn, survey_id: survey_id} do
      {:ok, view, _html} = live(conn, ~p"/survey/participate/#{survey_id}")
      _ = submit_nickname_form_response(view)
      _ = assert_patch(view)
      _ = submit_screening_form_response(view)
      _ = assert_patch(view)
      _ = submit_contact_details_form_response(view)
      _ = assert_patch(view)
      _ = submit_demographics_form_response(view)
      _ = assert_patch(view)
      _ = submit_context_form_response(view)
      _ = assert_patch(view)

      _resulting_html = submit_comparison_form_response(view, @comparison_form_params)

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{survey_id}/desired-outcome-ratings"
      assert has_element?(view, "h2", "Desired Outcome Ratings")
      assert_comparison_page_query_params(path)
    end
  end

  describe "Desired Outcome Rating Form" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to submit their desired outcome ratings, THEN: The thank you page is displayed", %{conn: conn, survey_id: survey_id} do
      {:ok, view, _html} = live(conn, ~p"/survey/participate/#{survey_id}")
      _ = submit_nickname_form_response(view)
      _ = assert_patch(view)
      _ = submit_screening_form_response(view)
      _ = assert_patch(view)
      _ = submit_contact_details_form_response(view)
      _ = assert_patch(view)
      _ = submit_demographics_form_response(view)
      _ = assert_patch(view)
      _ = submit_context_form_response(view)
      _ = assert_patch(view)
      _ = submit_comparison_form_response(view)
      _ = assert_patch(view)

      _resulting_html = submit_desired_outcome_rating_form_response(view, @desired_outcome_form_params)

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{survey_id}/thank-you"
      assert has_element?(view, "h2", "Thank You!")
    end
  end
end
