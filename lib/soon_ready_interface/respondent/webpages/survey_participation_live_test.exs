defmodule SoonReadyInterface.Respondent.Webpages.SurveyParticipationLiveTest do
  use SoonReadyInterface.ConnCase
  import Phoenix.LiveViewTest

  alias SoonReadyInterface.Respondent.ReadModels.Survey


  # FORM PARAMS

  @nickname_form_params %{
    "responses" => %{"0" => %{"response" => "A Nickname"}},
  }

  @correct_screening_form_params %{
    "responses" => %{
      "0" => %{"response" => "Option 1"},
      "1" => %{"response" => "Option 1"}
    }
  }

  @incorrect_screening_form_params %{
    "responses" => %{
      "0" => %{"response" => "Option 1"},
      "1" => %{"response" => "Option 2"}
    }
  }

  @contact_details_form_params %{
    "responses" => %{
      "0" => %{"response" => "hello@example.com"},
      "1" => %{"response" => "1234567890"}
    }
  }

  @demographics_form_params %{
    "responses" => %{
      "0" => %{"response" => "Option 1"},
      "1" => %{"response" => "Option 1"}
    }
  }

  @context_form_params %{
    "responses" => %{
      "0" => %{"response" => "Option 1"},
      "1" => %{"response" => "Option 1"}
    }
  }

  @comparison_form_params %{
    "responses" => %{
      "0" => %{"response" => "Product 1, Service 2, Platform 3"},
      "1" => %{"response" => "Thing 1, Thing 2"},
      "2" => %{"response" => "1000"},
      "3" => %{"response" => "Yes"},
      "4" => %{"response" => "1000"},
    }
  }

  @desired_outcome_form_params %{
    "responses" => %{
      "0" => %{
        "prompt_responses" => %{
          "0" => %{"question_responses" => %{"0" => %{"response" => "Very Important"}, "1" => %{"response" => "Very Satisfied"}}},
          "1" => %{"question_responses" => %{"0" => %{"response" => "Somewhat Important"}, "1" => %{"response" => "Satisfied"}}},
        }
      },
      "1" => %{
        "prompt_responses" => %{
          "0" => %{"question_responses" => %{"0" => %{"response" => "Not At All Important"}, "1" => %{"response" => "Extremely Satisfied"}}},
          "1" => %{"question_responses" => %{"0" => %{"response" => "Important"}, "1" => %{"response" => "Somewhat Satisfied"}}},
        }
      },
    }
  }


  # QUERY PARAMS

  @landing_page_query_params %{"nickname" => "A Nickname"}

  @screening_page_query_params %{
    "0" => %{"prompt" => "What is the answer to screening question 1?", "response" => "Option 1"},
    "1" => %{"prompt" => "What is the answer to screening question 2?", "response" => "Option 1"}
  }

  @contact_details_page_query_params %{
    "email" => "hello@example.com",
    "phone_number" => "1234567890"
  }

  @demographics_page_query_params %{
    "0" => %{"prompt" => "What is the answer to demographic question 1?", "response" => "Option 1"},
    "1" => %{"prompt" => "What is the answer to demographic question 2?", "response" => "Option 1"}
  }

  @context_page_query_params %{
    "0" => %{"prompt" => "What is the answer to context question 1?", "response" => "Option 1"},
    "1" => %{"prompt" => "What is the answer to context question 2?", "response" => "Option 1"}
  }

  @comparison_page_query_params %{
    "0" => %{"prompt" => "What products, services or platforms have you used to do what persons do?", "response" => "Product 1, Service 2, Platform 3"},
    "1" => %{"prompt" => "What additional things do you usually use/require when you're using any of the above?", "response" => "Thing 1, Thing 2"},
    "2" => %{"prompt" => "In total, how much would you estimate that you spend annually to do what persons do?", "response" => "1000"},
    "3" => %{"prompt" => "Would you be willing to pay more for a better solution?", "response" => "Yes"},
    "4" => %{"prompt" => "If yes, how much extra would you be willing to pay annually to get the job done perfectly?", "response" => "1000"}
  }

  setup do
    params = %{
      first_name: "John",
      last_name: "Doe",
      username: "john.doe",
      password: "outatime1985",
      password_confirmation: "outatime1985",
    }
    {:ok, %{researcher_id: researcher_id} = command} = SoonReadyInterface.Admin.register_researcher(params)
    {:ok, user} = SoonReady.IdentityAndAccessManagement.Resources.User.sign_in_with_password(params.username, params.password)


    screening_questions = [
      %{type: "multiple_choice_question", id: Ash.UUID.generate(), prompt: "What is the answer to screening question 1?", options: [
        %{type: "option_with_correct_flag", value: "Option 1", correct?: true},
        %{type: "option_with_correct_flag", value: "Option 2", correct?: false},
      ]},
      %{type: "multiple_choice_question", id: Ash.UUID.generate(), prompt: "What is the answer to screening question 2?", options: [
        %{type: "option_with_correct_flag", value: "Option 1", correct?: true},
        %{type: "option_with_correct_flag", value: "Option 2", correct?: false},
      ]}
    ]
    demographic_questions = [
      %{type: "multiple_choice_question", prompt: "What is the answer to demographic question 1?", options: ["Option 1", "Option 2"]},
      %{type: "multiple_choice_question", prompt: "What is the answer to demographic question 2?", options: ["Option 1", "Option 2"]}
    ]
    context_questions = [
      %{type: "multiple_choice_question", prompt: "What is the answer to context question 1?", options: ["Option 1", "Option 2"]},
      %{type: "multiple_choice_question", prompt: "What is the answer to context question 2?", options: ["Option 1", "Option 2"]}
    ]

    {:ok, %{survey_id: survey_id, project_id: project_id} = _command} = SoonReadyInterface.Researcher.create_survey(%{
      brand_name: "A Big Brand",
      market: %{job_executor: "Persons", job_to_be_done: "Do what persons do"},
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
      screening_questions: screening_questions,
      demographic_questions: demographic_questions,
      context_questions: context_questions,
    })

    %{survey_id: survey_id, survey: Survey.get_active!(survey_id)}
  end

  describe "Landing Page" do
    test "WHEN: A participant tries to visit the survey participation url, THEN: The participant is redirected to the landing page", %{conn: conn, survey_id: survey_id, survey: %{starting_page_id: starting_page_id} = survey} do
      {:error, {:live_redirect, %{to: destination_url}}} = live(conn, ~p"/survey/participate/#{survey_id}")

      assert destination_url == "/survey/participate/#{survey_id}/pages/#{starting_page_id}"
    end

    test "WHEN: Respondent tries to visit the survey participation url, THEN: The landing page is displayed", %{conn: conn, survey_id: survey_id, survey: %{starting_page_id: starting_page_id} = survey} do
      {:ok, view, html} = live(conn, ~p"/survey/participate/#{survey_id}/pages/#{starting_page_id}")

      assert html =~ "Welcome to our Survey!"
    end

    test "GIVEN: Respondent has visited the survey participation url, WHEN: Respondent tries to submit a nickname, THEN: The screening questions page is displayed", %{conn: conn, survey_id: survey_id, survey: %{starting_page_id: starting_page_id, pages: pages} = survey} do
      {:ok, view, html} = live(conn, ~p"/survey/participate/#{survey_id}/pages/#{starting_page_id}")

      _resulting_html = submit_form_response(view, @nickname_form_params)

      landing_page = get_page_by_title(pages, "Welcome to our Survey!")
      screening_page = get_page_by_title(pages, "Screening Questions")

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{survey_id}/pages/#{screening_page.id}"
      assert has_element?(view, "h2", "Screening Questions")
      assert_page_response_in_query_params(path, landing_page.id)
    end
  end

  describe "Screening Questions Form" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to respond correctly to the screening questions, THEN: The contact details page is displayed", %{conn: conn, survey_id: survey_id, survey: %{starting_page_id: starting_page_id, pages: pages} = survey} do
      {:ok, view, html} = live(conn, ~p"/survey/participate/#{survey_id}/pages/#{starting_page_id}")
      _ = submit_form_response(view, @nickname_form_params)
      _ = assert_patch(view)

      _resulting_html = submit_form_response(view, @correct_screening_form_params)

      screening_page = get_page_by_title(pages, "Screening Questions")
      contact_details_page = get_page_by_title(pages, "Contact Details")

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{survey_id}/pages/#{contact_details_page.id}"
      assert has_element?(view, "h2", "Contact Details")
      assert_page_response_in_query_params(path, screening_page.id)
    end

    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to respond incorrectly to the screening questions, THEN: The thank you page is displayed", %{conn: conn, survey_id: survey_id, survey: %{starting_page_id: starting_page_id, pages: pages} = survey} do
      {:ok, view, html} = live(conn, ~p"/survey/participate/#{survey_id}/pages/#{starting_page_id}")
      _ = submit_form_response(view, @nickname_form_params)
      _ = assert_patch(view)

      _resulting_html = submit_form_response(view, @incorrect_screening_form_params)

      thank_you_page = get_page_by_title(pages, "Thank You!")

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{survey_id}/pages/#{thank_you_page.id}"
      assert has_element?(view, "h2", "Thank You!")
    end
  end

  describe "Contact Details Form" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to submit their contact details, THEN: The demographics page is displayed", %{conn: conn, survey_id: survey_id, survey: %{starting_page_id: starting_page_id, pages: pages} = survey} do
      {:ok, view, html} = live(conn, ~p"/survey/participate/#{survey_id}/pages/#{starting_page_id}")
      _ = submit_form_response(view, @nickname_form_params)
      _ = assert_patch(view)
      _ = submit_form_response(view, @correct_screening_form_params)
      _ = assert_patch(view)

      _resulting_html = submit_form_response(view, @contact_details_form_params)

      contact_details_page = get_page_by_title(pages, "Contact Details")
      demographics_page = get_page_by_title(pages, "Demographics")

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{survey_id}/pages/#{demographics_page.id}"
      assert has_element?(view, "h2", "Demographics")
      assert_page_response_in_query_params(path, contact_details_page.id)
    end
  end

  describe "Demographics Form" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to submit their demographic details, THEN: The context page is displayed", %{conn: conn, survey_id: survey_id, survey: %{starting_page_id: starting_page_id, pages: pages} = survey} do
      {:ok, view, html} = live(conn, ~p"/survey/participate/#{survey_id}/pages/#{starting_page_id}")
      _ = submit_form_response(view, @nickname_form_params)
      _ = assert_patch(view)
      _ = submit_form_response(view, @correct_screening_form_params)
      _ = assert_patch(view)
      _ = submit_form_response(view, @contact_details_form_params)
      _ = assert_patch(view)

      _resulting_html = submit_form_response(view, @demographics_form_params)

      demographics_page = get_page_by_title(pages, "Demographics")
      context_page = get_page_by_title(pages, "Context")

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{survey_id}/pages/#{context_page.id}"
      assert has_element?(view, "h2", "Context")
      assert_page_response_in_query_params(path, demographics_page.id)
    end
  end

  describe "Context Form" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to submit their context details, THEN: The comparison page is displayed", %{conn: conn, survey_id: survey_id, survey: %{starting_page_id: starting_page_id, pages: pages} = survey} do
      {:ok, view, html} = live(conn, ~p"/survey/participate/#{survey_id}/pages/#{starting_page_id}")
      _ = submit_form_response(view, @nickname_form_params)
      _ = assert_patch(view)
      _ = submit_form_response(view, @correct_screening_form_params)
      _ = assert_patch(view)
      _ = submit_form_response(view, @contact_details_form_params)
      _ = assert_patch(view)
      _ = submit_form_response(view, @demographics_form_params)
      _ = assert_patch(view)

      _resulting_html = submit_form_response(view, @context_form_params)

      demographics_page = get_page_by_title(pages, "Demographics")
      comparison_page = get_page_by_title(pages, "Comparison")

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{survey_id}/pages/#{comparison_page.id}"
      assert has_element?(view, "h2", "Comparison")
      assert_page_response_in_query_params(path, demographics_page.id)
    end
  end

  describe "Comparison Form" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to submit their comparison details, THEN: The desired outcome rating page is displayed", %{conn: conn, survey_id: survey_id, survey: %{starting_page_id: starting_page_id, pages: pages} = survey} do
      {:ok, view, html} = live(conn, ~p"/survey/participate/#{survey_id}/pages/#{starting_page_id}")
      _ = submit_form_response(view, @nickname_form_params)
      _ = assert_patch(view)
      _ = submit_form_response(view, @correct_screening_form_params)
      _ = assert_patch(view)
      _ = submit_form_response(view, @contact_details_form_params)
      _ = assert_patch(view)
      _ = submit_form_response(view, @demographics_form_params)
      _ = assert_patch(view)
      _ = submit_form_response(view, @context_form_params)
      _ = assert_patch(view)

      _resulting_html = submit_form_response(view, @comparison_form_params)

      comparison_page = get_page_by_title(pages, "Comparison")
      desired_outcome_ratings_page = get_page_by_title(pages, "Desired Outcome Ratings")

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{survey_id}/pages/#{desired_outcome_ratings_page.id}"
      assert has_element?(view, "h2", "Desired Outcome Ratings")
      assert_page_response_in_query_params(path, comparison_page.id)
    end
  end

  describe "Desired Outcome Rating Form" do
    test "GIVEN: Forms in previous pages have been filled, WHEN: Respondent tries to submit their desired outcome ratings, THEN: The thank you page is displayed", %{conn: conn, survey_id: survey_id, survey: %{starting_page_id: starting_page_id, pages: pages} = survey} do
      {:ok, view, html} = live(conn, ~p"/survey/participate/#{survey_id}/pages/#{starting_page_id}")
      _ = submit_form_response(view, @nickname_form_params)
      _ = assert_patch(view)
      _ = submit_form_response(view, @correct_screening_form_params)
      _ = assert_patch(view)
      _ = submit_form_response(view, @contact_details_form_params)
      _ = assert_patch(view)
      _ = submit_form_response(view, @demographics_form_params)
      _ = assert_patch(view)
      _ = submit_form_response(view, @context_form_params)
      _ = assert_patch(view)
      _ = submit_form_response(view, @comparison_form_params)
      _ = assert_patch(view)

      _resulting_html = submit_form_response(view, @desired_outcome_form_params)

      thank_you_page = get_page_by_title(pages, "Thank You!")

      path = assert_patch(view)
      assert path =~ ~p"/survey/participate/#{survey_id}/pages/#{thank_you_page.id}"
      assert has_element?(view, "h2", "Thank You!")
    end
  end

  def submit_form_response(view, params) do
    view
    |> form("form", form: params)
    |> put_submitter("button[name=submit]")
    |> render_submit()
  end

  def assert_page_response_in_query_params(path, page_id) do
    %{query: query} = URI.parse(path)
    %{"pages" => pages_query_params} = Plug.Conn.Query.decode(query)
    assert Map.get(pages_query_params, page_id) != nil
  end

  def get_page_by_title(pages, title) do
    pages
    |> Enum.filter(fn page ->
      to_string(page.title) == title
    end)
    |> Enum.at(0)
  end
end
