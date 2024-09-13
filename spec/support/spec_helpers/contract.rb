module SpecHelpers
  module Contract
    def mock_unsuccessful_match_back
      expect_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
        receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)
    end

    def mock_successful_match_back
      expect_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
        receive(:create_candidate_access_token)
    end

    def mock_exchange_code_for_candidate(candidate_identity)
      expect_any_instance_of(GetIntoTeachingApiClient::TeacherTrainingAdviserApi).to \
        receive(:exchange_access_token_for_teacher_training_adviser_sign_up) do
          path = Rails.root.join("spec/contracts/data/teacher_training_adviser/candidates.json")
          data = JSON.parse(File.open(path).read).map { |d| d.transform_keys(&:underscore) }
          matchback_values = candidate_identity.to_hash.except(:existing).values.map(&:downcase)
          candidate_data = data.find do |d|
            [d["first_name"], d["last_name"], d["email"]].map(&:downcase) == matchback_values
          end
          filtered_candidate_data = candidate_data.except("address_line1", "address_line2", "address_city")

          GetIntoTeachingApiClient::TeacherTrainingAdviserSignUp.new(filtered_candidate_data).tap do |c|
            c.date_of_birth = Date.parse(filtered_candidate_data["date_of_birth"]) if filtered_candidate_data["date_of_birth"].present?
          end
        end
    end

    def setup_data
      setup_pick_list_items
      setup_lookup_items
      setup_privacy_policy
      setup_callback_booking_quotas
    end

    def state
      path = Rails.root.join("spec/contracts/data/state.json")
      JSON.parse(File.open(path).read)
    end

    def setup_pick_list_items
      read_data("pick_list_items").each do |hash|
        items = hash[:values].map do |item|
          GetIntoTeachingApiClient::PickListItem.new(item.slice("id", "value"))
        end

        allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
          receive(hash[:method]) { items }
      end
    end

    def setup_lookup_items
      read_data("lookup_items").each do |hash|
        items = hash[:values].map do |item|
          case item["entityName"]
          when "dfe_country"
            GetIntoTeachingApiClient::Country.new(item.slice("id", "value"))
          when "dfe_teachingsubjectlist"
            GetIntoTeachingApiClient::TeachingSubject.new(item.slice("id", "value"))
          else
            raise RuntimeError("Unrecognized lookup item: #{item}")
          end
        end

        allow_any_instance_of(GetIntoTeachingApiClient::LookupItemsApi).to \
          receive(hash[:method]) { items }
      end
    end

    def setup_privacy_policy
      path = Rails.root.join("spec/contracts/data/privacy_policy.json")
      policy_data = JSON.parse(File.open(path).read)
      policy = GetIntoTeachingApiClient::PrivacyPolicy.new(policy_data.slice("id", "text"))

      allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to \
        receive(:get_latest_privacy_policy) { policy }

      allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to \
        receive(:get_privacy_policy).with(policy.id) { policy }
    end

    def setup_callback_booking_quotas
      path = Rails.root.join("spec/contracts/data/callback_booking_quotas.json")
      quotas_data = JSON.parse(File.open(path).read)
      quotas = quotas_data.map do |data|
        data.transform_keys!(&:underscore)

        GetIntoTeachingApiClient::CallbackBookingQuota.new(data).tap do |q|
          q.start_at = Time.zone.parse(data["start_at"])
          q.end_at = Time.zone.parse(data["end_at"])
        end
      end

      allow_any_instance_of(GetIntoTeachingApiClient::CallbackBookingQuotasApi).to \
        receive(:get_callback_booking_quotas) { quotas }
    end

    def read_data(folder)
      path = Rails.root.join("spec/contracts/data/#{folder}/**/*.json")
      Dir[path].map do |data_file|
        {
          method: "get#{data_file.split(folder).last.gsub('/', '_').chomp('.json')}",
          values: JSON.parse(File.open(data_file).read),
        }
      end
    end

    def setup_contract
      expect_any_instance_of(GetIntoTeachingApiClient::TeacherTrainingAdviserApi).to \
        receive(:sign_up_teacher_training_adviser_candidate) do |_, request|
          request_json = request.to_json

          unless File.exist?(contract_output_file)
            File.write(contract_output_file, request_json)
          end

          expect(JSON.parse(request_json)).to eq(JSON.parse(File.open(contract_output_file).read))
        end
    end

    def contract_output_file
      filename = RSpec.current_example.metadata[:full_description].parameterize(separator: "_")
      Rails.root.join("spec", "contracts", "output", "#{filename}.json")
    end

    def expect_current_step(step)
      expect(page).to have_current_path(teacher_training_adviser_step_path(step))
    end

    def click_on_continue
      click_on "Next"
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
      {
        first_name: "Jane",
        last_name: "Doe",
        email: "existing@user.com",
        existing: true,
      }
    end

    def existing_closed_candidate_identity
      {
        first_name: "Jim",
        last_name: "Doe",
        email: "existing.closed@user.com",
        existing: true,
      }
    end

    def submit_choice_step(option, step)
      expect_current_step(step)
      choose option
      click_on_continue
    end

    def submit_select_step(option, step)
      expect_current_step(step)
      select option
      click_on_continue
    end

    def submit_fill_in_step(field, value, step)
      expect_current_step(step)
      fill_in field, with: value
      click_on_continue
    end

    def submit_identity_step(first_name:, last_name:, email:, existing: false)
      expect_current_step(:identity)

      fill_in "First name", with: first_name
      fill_in "Last name", with: last_name
      fill_in "Email address", with: email

      if existing
        mock_successful_match_back
      else
        mock_unsuccessful_match_back
      end

      click_on_continue
    end

    def submit_date_of_birth_step(date)
      expect_current_step(:date_of_birth)

      fill_in "Day", with: date.day
      fill_in "Month", with: date.month
      fill_in "Year", with: date.year

      click_on_continue
    end

    def submit_uk_address_step(postcode:)
      expect_current_step(:uk_address)

      fill_in "What is your postcode?", with: postcode

      click_on_continue
    end

    def submit_previous_teacher_id_step(teacher_id)
      expect_current_step(:previous_teacher_id)

      fill_in "Teacher reference number (optional)", with: teacher_id
      click_on_continue
    end

    def submit_uk_telephone_step(telephone = nil)
      expect_current_step(:uk_telephone)

      fill_in "UK telephone number (optional)", with: telephone
      click_on_continue
    end

    def submit_overseas_telephone_step(telephone = nil)
      expect_current_step(:overseas_telephone)

      fill_in "Overseas telephone number (optional)", with: telephone
      click_on_continue
    end

    def submit_uk_callback_step(telephone, slot = nil)
      expect_current_step(:uk_callback)

      fill_in "Contact telephone number", with: telephone
      select slot if slot.present?
      click_on_continue
    end

    def submit_overseas_time_zone_step(telephone, timezone)
      expect_current_step(:overseas_time_zone)

      fill_in "Contact telephone number", with: telephone
      select timezone
      click_on_continue
    end

    def submit_review_answers_step
      expect_current_step(:review_answers)
      click_on "Complete sign up"
    end

    def submit_verification_code(candidate_identity)
      fill_in "git-wizard-steps-authenticate-timed-one-time-password-field", with: "123456"
      mock_exchange_code_for_candidate(candidate_identity)
      click_on_continue
    end
  end
end
