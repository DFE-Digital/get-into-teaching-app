require "rails_helper"

RSpec.describe "Teacher training adviser sign up", type: :feature, vcr: false do
  before do
    setup_data
    setup_contract

    visit teacher_training_adviser_steps_path

    submit_identity_step(**candidate_identity)
  end

  around do |example|
    travel_to(Time.zone.parse(state["utcNow"]))
    VCR.turned_off { example.run }
    travel_back
  end

  context "with a new candidate" do
    let(:candidate_identity) { new_candidate_identity }

    it "returning, teacher reference number, in the UK and telephone" do
      submit_choice_step("Yes", :returning_teacher)
      submit_choice_step("Yes", :has_teacher_id)
      submit_previous_teacher_id_step("12345")
      submit_choice_step("Secondary", :stage_taught)
      submit_select_step("Maths", :subject_taught)
      submit_choice_step("Secondary", :stage_interested_teaching)
      submit_select_step("Physics", :subject_like_to_teach)
      submit_date_of_birth_step(Date.new(1974, 3, 16))
      submit_choice_step("UK", :uk_or_overseas)
      submit_uk_address_step(
        postcode: "TE7 5TR",
      )
      submit_uk_telephone_step("123456789")
      submit_review_answers_step
      expect(page).to have_text("you're signed up")
    end

    it "returning, no teacher reference number, overseas and no telephone" do
      submit_choice_step("Yes", :returning_teacher)
      submit_choice_step("Yes", :has_teacher_id)
      submit_previous_teacher_id_step("12345")
      submit_choice_step("Secondary", :stage_taught)
      submit_select_step("Maths", :subject_taught)
      submit_choice_step("Secondary", :stage_interested_teaching)
      submit_select_step("Physics", :subject_like_to_teach)
      submit_date_of_birth_step(Date.new(1974, 3, 16))
      submit_choice_step("Overseas", :uk_or_overseas)
      submit_select_step("Brazil", :overseas_country)
      submit_overseas_telephone_step
      submit_review_answers_step
      expect(page).to have_text("you're signed up")
    end

    it "not returning, has degree, primary, has gcses, in the UK and telephone" do
      submit_choice_step("No", :returning_teacher)
      submit_choice_step("Yes", :have_a_degree)
      submit_fill_in_step("What subject is your degree?", "Physics", :what_subject_degree)
      submit_select_step("2:1", :what_degree_class)
      submit_choice_step("Primary", :stage_interested_teaching)
      submit_choice_step("Yes", :gcse_maths_english)
      submit_choice_step("Yes", :gcse_science)
      submit_select_step("2022", :start_teacher_training)
      submit_date_of_birth_step(Date.new(1974, 3, 16))
      submit_choice_step("UK", :uk_or_overseas)
      submit_uk_address_step(
        postcode: "TE7 5TR",
      )
      submit_uk_telephone_step("123456789")
      submit_review_answers_step
      expect(page).to have_text("you're signed up")
    end

    it "not returning, has degree, secondary, retaking gcses, overseas and no telephone" do
      submit_choice_step("No", :returning_teacher)
      submit_choice_step("Yes", :have_a_degree)
      submit_fill_in_step("What subject is your degree?", "Mathematics", :what_subject_degree)
      submit_select_step("Not applicable", :what_degree_class)
      submit_choice_step("Secondary", :stage_interested_teaching)
      submit_choice_step("No", :gcse_maths_english)
      submit_choice_step("Yes", :retake_gcse_maths_english)
      submit_select_step("Chemistry", :subject_interested_teaching)
      submit_select_step("Not sure", :start_teacher_training)
      submit_date_of_birth_step(Date.new(1974, 3, 16))
      submit_choice_step("Overseas", :uk_or_overseas)
      submit_select_step("Canada", :overseas_country)
      submit_overseas_telephone_step
      submit_review_answers_step
      expect(page).to have_text("you're signed up")
    end

    it "not returning, studying for degree (not final year), overseas and telephone" do
      submit_choice_step("No", :returning_teacher)
      submit_choice_step("I'm studying for a degree", :have_a_degree)
      submit_choice_step("First year", :stage_of_degree)
      submit_fill_in_step("What subject is your degree?", "Physics", :what_subject_degree)
      submit_choice_step("Secondary", :stage_interested_teaching)
      submit_select_step("Maths", :subject_interested_teaching)
      submit_date_of_birth_step(Date.new(1974, 3, 16))
      submit_choice_step("Overseas", :uk_or_overseas)
      submit_select_step("Barbados", :overseas_country)
      submit_overseas_telephone_step("123456789")
      submit_review_answers_step
      expect(page).to have_text("you're signed up")
    end

    it "not returning, studying for degree (final year), overseas and telephone" do
      submit_choice_step("No", :returning_teacher)
      submit_choice_step("I'm studying for a degree", :have_a_degree)
      submit_choice_step("Final year", :stage_of_degree)
      submit_fill_in_step("What subject is your degree?", "Physics", :what_subject_degree)
      submit_select_step("First class", :what_degree_class)
      submit_choice_step("Primary", :stage_interested_teaching)
      submit_choice_step("No", :gcse_maths_english)
      submit_choice_step("Yes", :retake_gcse_maths_english)
      submit_choice_step("Yes", :gcse_science)
      submit_select_step("2021", :start_teacher_training)
      submit_date_of_birth_step(Date.new(1974, 3, 16))
      submit_choice_step("Overseas", :uk_or_overseas)
      submit_select_step("Barbados", :overseas_country)
      submit_overseas_telephone_step("123456789")
      submit_review_answers_step
      expect(page).to have_text("you're signed up")
    end

    it "not returning, equivalent degree, primary, has/retaking gcses, overseas" do
      submit_choice_step("No", :returning_teacher)
      submit_choice_step("I am not a UK citizen and have, or am studying for, an equivalent qualification", :have_a_degree)
      submit_choice_step("Primary", :stage_interested_teaching)
      submit_select_step("2022", :start_teacher_training)
      submit_date_of_birth_step(Date.new(1974, 3, 16))
      submit_choice_step("UK", :uk_or_overseas)
      submit_uk_address_step(
        postcode: "TE7 5TR",
      )
      submit_uk_callback_step("123456789", "1:00pm to 1:30pm")
      submit_review_answers_step
      expect(page).to have_text("We'll give you a call")
    end

    it "not returning, equivalent degree, secondary, has gcses, is in uk" do
      submit_choice_step("No", :returning_teacher)
      submit_choice_step("I am not a UK citizen and have, or am studying for, an equivalent qualification", :have_a_degree)
      submit_choice_step("Secondary", :stage_interested_teaching)
      submit_select_step("Maths", :subject_interested_teaching)
      submit_select_step("2021", :start_teacher_training)
      submit_date_of_birth_step(Date.new(1974, 3, 16))
      submit_choice_step("Overseas", :uk_or_overseas)
      submit_select_step("China", :overseas_country)
      submit_overseas_time_zone_step("447584736574", "(GMT-04:00) Caracas")
      submit_select_step("9:00am to 9:30am", :overseas_callback)
      submit_review_answers_step
      expect(page).to have_text("We'll give you a call")
    end
  end

  context "with an existing candidate" do
    let(:candidate_identity) { existing_candidate_identity }

    it "returning, existing data, change address" do
      submit_verification_code(candidate_identity)
      submit_choice_step("Yes", :returning_teacher)

      expect_current_step(:stage_taught)
      submit_choice_step("Secondary", :stage_taught)

      expect_current_step(:subject_taught)
      submit_select_step("Maths", :subject_taught)

      expect_current_step(:stage_interested_teaching)
      expect(page.find_field("Secondary")).to be_checked
      click_on_continue

      expect_current_step(:subject_like_to_teach)
      expect(page).to have_select("Which subject would you like to teach if you return to teaching?", selected: "Physics")
      click_on_continue

      expect_current_step(:date_of_birth)
      expect(find_field("Day").value).to eq("22")
      expect(find_field("Month").value).to eq("3")
      expect(find_field("Year").value).to eq("1987")
      click_on_continue

      submit_choice_step("UK", :uk_or_overseas)

      expect_current_step(:uk_address)
      expect(find_field("What is your postcode?").value).to eq("KY9 6NJ")

      submit_uk_address_step(
        postcode: "TE7 5TR",
      )

      submit_review_answers_step
    end

    context "when in a closed state" do
      let(:candidate_identity) { existing_closed_candidate_identity }

      it "not returning, existing data, change country" do
        submit_verification_code(candidate_identity)
        submit_choice_step("No", :returning_teacher)
        submit_choice_step("Yes", :have_a_degree)

        expect_current_step(:what_subject_degree)
        expect(page.find_field("What subject is your degree?").value).to eql("Mathematics")
        click_on_continue

        expect_current_step(:what_degree_class)
        expect(page).to have_select("Which class is your degree?", selected: "First class")
        click_on_continue

        expect_current_step(:stage_interested_teaching)
        expect(page.find_field("Secondary")).to be_checked
        click_on_continue

        expect_current_step(:gcse_maths_english)
        expect(page.find_field("Yes")).to be_checked
        click_on_continue

        expect_current_step(:subject_interested_teaching)
        expect(page).to have_select("What would you like to teach?", selected: "Physics")
        click_on_continue

        expect_current_step(:start_teacher_training)
        expect(page).to have_select("When do you want to start your teacher training?", selected: "Not sure")
        click_on_continue

        expect_current_step(:date_of_birth)
        expect(find_field("Day").value).to eq("22")
        expect(find_field("Month").value).to eq("3")
        expect(find_field("Year").value).to eq("1987")
        click_on_continue

        submit_choice_step("Overseas", :uk_or_overseas)

        expect_current_step(:overseas_country)
        expect(page).to have_select("Which country do you live in?", selected: "Bahamas")
        submit_select_step("Brazil", :overseas_country)

        submit_review_answers_step
      end
    end
  end
end
