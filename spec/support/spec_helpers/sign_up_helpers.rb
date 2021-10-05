module SpecHelpers
  module SignUpHelpers
    def mock_unsuccessful_match_back
      allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
        receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)
    end

    def mock_successful_match_back
      allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
        receive(:create_candidate_access_token)
    end

    def submit_name_step(first_name:, last_name:, email:, existing: false)
      expect_current_step(:name)

      fill_in "First name", with: first_name
      fill_in "Last name", with: last_name
      fill_in "Email address", with: email

      if existing
        mock_successful_match_back
      else
        mock_unsuccessful_match_back
      end

      click_on_next_step
    end

    def expect_exit_step(text)
      expect(page).to have_text text
      expect(page).not_to have_button("Next step")
    end

    def enter_verification_code_and_continue(email, valid_code, invalid_code = nil)
      if invalid_code.present?
        fill_in "Check your email and enter the verification code sent to #{email}", with: invalid_code
        click_on_next_step

        expect(page).to have_text "Please enter the latest verification code sent to your email address"
        click_on "resend verification"
        expect(page).to have_text "We've sent you another email."
      end

      fill_in "Check your email and enter the verification code sent to #{email}", with: valid_code
      click_on_next_step
    end

    def expect_current_step(step)
      expect(page).to have_current_path(mailing_list_step_path(step), ignore_query: true)
    end

    def expect_not_current_step(step)
      expect(page).not_to have_current_path(mailing_list_step_path(step), ignore_query: true)
    end

    def click_on_next_step
      click_on "Next step"
    end

    def new_candidate_identity
      {
        first_name: "John",
        last_name: "Doe",
        email: "john@doe.com",
        existing: false,
      }
    end

    def existing_candidate_identity
      new_candidate_identity.tap do |identity|
        identity[:existing] = true
      end
    end

    def submit_select_step(option, step)
      expect_current_step(step)
      select option
      click_on_next_step
    end

    def submit_choice_step(option, step)
      expect_current_step(step)
      choose option
      click_on_next_step
    end

    def submit_input_step(name, text, step)
      expect_current_step(step)
      fill_in(name, with: text)
      click_on_next_step
    end

    def submit_privacy_policy_step
      expect_current_step(:privacy_policy)
      check "Yes"
      click_on "Complete sign up"
    end

    def submit_pre_filled_choice_step(option, step)
      expect_current_step(step)
      expect(page.find_field(option)).to be_checked
      click_on_next_step
    end

    def submit_pre_filled_select_step(_option, step)
      expect_current_step(step)
      expect(page).to have_select(selected: "Maths")
      click_on_next_step
    end
  end
end
