module SpecHelpers
  module Integration
    def config_capybara
      host = Rails.application.config.x.integration_host
      creds = Rails.application.config.x.integration_credentials
      Capybara.run_server = false
      Capybara.app_host = "https://#{creds[:username]}:#{creds[:password]}@#{host}"
    end

    def submit_personal_details(first_name, last_name, email)
      fill_in "First name", with: first_name
      fill_in "Last name", with: last_name
      fill_in "Email address", with: email
      click_on "Next step"
    end

    def submit_code(email)
      wait_for_jobs
      expect(page).to have_text("You're already registered with us")
      code = retrieve_verification_code(email)
      fill_in "To verify your details, we've sent a code to your email address.", with: code
      click_on "Next step"
    end

    def rand
      Random.rand(1...10_000)
    end

    def click_label(text)
      # Capybara choose/check methods aren't working
      # for radio/checkbox inputs on integration tests.
      find("label", text: text).click
    end

    def rand_first_name
      "First-#{rand}"
    end

    def rand_last_name
      "Last-#{rand}"
    end

    def rand_email
      "#{rand}@#{rand}.com"
    end

    def wait_for_jobs
      sleep 5
    end

    def retrieve_verification_code(email)
      api_key = Rails.application.config.x.mailsac_api_key
      emails_response = Faraday.get("https://mailsac.com/api/addresses/#{email}/messages?_mailsacKey=#{api_key}")
      emails = JSON.parse(emails_response.body)
      latest_email_id = emails.first["_id"]

      email_response = Faraday.get("https://mailsac.com/api/text/#{email}/#{latest_email_id}?_mailsacKey=#{api_key}")
      email_body = email_response.body

      email_body[/\d{6}/, 0]
    end
  end
end
