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

    context "when returning" do
      it "teacher reference number, paid UK experience, in the UK and telephone" do
        submit_choice_step("Yes", :returning_teacher)
        submit_choice_step("Yes", :has_teacher_id)
        submit_previous_teacher_id_step("12345")
        submit_choice_step("Yes", :paid_teaching_experience_in_uk)
        submit_choice_step("Secondary", :stage_taught)
        submit_select_step("Maths", :subject_taught)
        submit_choice_step("Secondary", :stage_interested_teaching)
        submit_select_step("Physics", :subject_like_to_teach)
        submit_date_of_birth_step(Date.new(1974, 3, 16))
        submit_choice_step("Yes", :citizenship)
        submit_choice_step("In the UK", :location)
        submit_uk_address_step(
          postcode: "TE7 5TR",
        )
        submit_uk_telephone_step("123456789")
        submit_review_answers_step
        expect(page).to have_text("you're signed up")

        expect(page).to have_css "#teacher-training-citizenship[data-id=222750000]", visible: false
        expect(page).to have_css "#teacher-training-location[data-id=222750000]", visible: false
      end

      it "no teacher reference number, paid UK experience, overseas and no telephone" do
        submit_choice_step("Yes", :returning_teacher)
        submit_choice_step("Yes", :has_teacher_id)
        submit_previous_teacher_id_step("12345")
        submit_choice_step("Yes", :paid_teaching_experience_in_uk)
        submit_choice_step("Secondary", :stage_taught)
        submit_select_step("Maths", :subject_taught)
        submit_choice_step("Secondary", :stage_interested_teaching)
        submit_select_step("Physics", :subject_like_to_teach)
        submit_date_of_birth_step(Date.new(1974, 3, 16))
        submit_choice_step("No", :citizenship)
        submit_choice_step("Yes, I have a visa, pre-settled status or leave to remain", :visa_status)
        submit_choice_step("Outside of the UK", :location)
        submit_select_step("Brazil", :overseas_country)
        submit_overseas_telephone_step
        submit_review_answers_step
        expect(page).to have_text("you're signed up")

        expect(page).to have_css "#teacher-training-citizenship[data-id=222750001]", visible: false
        expect(page).to have_css "#teacher-training-visa-status[data-id=222750000]", visible: false
        expect(page).to have_css "#teacher-training-location[data-id=222750001]", visible: false
      end

      it "teacher reference number, no paid UK experience, trained in the uk, in the UK and telephone" do
        submit_choice_step("Yes", :returning_teacher)
        submit_choice_step("Yes", :has_teacher_id)
        submit_previous_teacher_id_step("12345")
        submit_choice_step("No", :paid_teaching_experience_in_uk)
        submit_choice_step("Yes", :train_to_teach_in_uk)
        submit_choice_step("Secondary", :stage_trained)
        submit_select_step("Maths", :subject_trained)
        submit_choice_step("Secondary", :stage_interested_teaching)
        submit_select_step("Physics", :subject_like_to_teach)
        submit_date_of_birth_step(Date.new(1974, 3, 16))
        submit_choice_step("Yes", :citizenship)
        submit_choice_step("In the UK", :location)
        submit_uk_address_step(
          postcode: "TE7 5TR",
        )
        submit_uk_telephone_step("123456789")
        submit_review_answers_step
        expect(page).to have_text("you're signed up")

        expect(page).to have_css "#teacher-training-citizenship[data-id=222750000]", visible: false
        expect(page).to have_css "#teacher-training-location[data-id=222750000]", visible: false
      end
    end

    context "when not returning" do
      it "has degree, primary, has gcses, in the UK and telephone" do
        submit_choice_step("No", :returning_teacher)
        submit_choice_step("Yes", :degree_status)
        submit_choice_step("The UK", :degree_country)
        submit_fill_in_step("What subject is your degree?", "Physics", :what_subject_degree)
        submit_choice_step("Upper second-class honours (2:1)", :what_degree_class)
        submit_choice_step("Graduated and exploring my career options", :life_stage)
        submit_choice_step("Primary", :stage_interested_teaching)
        submit_choice_step("Yes", :gcse_maths_english)
        submit_choice_step("Yes", :gcse_science)
        submit_choice_step("2022", :start_teacher_training)
        submit_date_of_birth_step(Date.new(1974, 3, 16))
        submit_choice_step("Yes", :citizenship)
        submit_choice_step("In the UK", :location)
        submit_uk_address_step(
          postcode: "TE7 5TR",
        )
        submit_uk_telephone_step("123456789")
        submit_review_answers_step
        expect(page).to have_text("you're signed up")

        expect(page).to have_css "#teacher-training-degree-status[data-id=222750000]", visible: false
        expect(page).to have_css "#teacher-training-degree-country[data-id='72f5c2e6-74f9-e811-a97a-000d3a2760f2']", visible: false
        expect(page).to have_css "#teacher-training-citizenship[data-id=222750000]", visible: false
        expect(page).to have_css "#teacher-training-situation[data-id=222750003]", visible: false
        expect(page).to have_css "#teacher-training-location[data-id=222750000]", visible: false
      end

      it "has degree, secondary, retaking gcses, overseas and no telephone" do
        submit_choice_step("No", :returning_teacher)
        submit_choice_step("Yes", :degree_status)
        submit_choice_step("The UK", :degree_country)
        submit_fill_in_step("What subject is your degree?", "Mathematics", :what_subject_degree)
        submit_choice_step("Other", :what_degree_class)
        submit_choice_step("Considering changing my existing career", :life_stage)
        submit_choice_step("Secondary", :stage_interested_teaching)
        submit_choice_step("No", :gcse_maths_english)
        submit_choice_step("Yes", :retake_gcse_maths_english)
        submit_select_step("Chemistry", :subject_interested_teaching)
        submit_choice_step("Not sure", :start_teacher_training)
        submit_date_of_birth_step(Date.new(1974, 3, 16))
        submit_choice_step("No", :citizenship)
        submit_choice_step("No, I will need to apply for a visa", :visa_status)
        submit_choice_step("Outside of the UK", :location)
        submit_select_step("Canada", :overseas_country)
        submit_overseas_telephone_step
        submit_review_answers_step
        expect(page).to have_text("you're signed up")

        expect(page).to have_css "#teacher-training-degree-status[data-id=222750000]", visible: false
        expect(page).to have_css "#teacher-training-degree-country[data-id='72f5c2e6-74f9-e811-a97a-000d3a2760f2']", visible: false
        expect(page).to have_css "#teacher-training-citizenship[data-id=222750001]", visible: false
        expect(page).to have_css "#teacher-training-situation[data-id=222750004]", visible: false
        expect(page).to have_css "#teacher-training-visa-status[data-id=222750001]", visible: false
        expect(page).to have_css "#teacher-training-location[data-id=222750001]", visible: false
      end

      it "studying for degree (not final year), overseas and telephone" do
        submit_choice_step("No", :returning_teacher)
        submit_graduation_year_step(2023)
        submit_choice_step("The UK", :degree_country)
        submit_fill_in_step("What subject is your degree?", "Physics", :what_subject_degree)
        submit_choice_step("Teaching assistant or unqualified teacher in a school", :life_stage)
        submit_choice_step("Secondary", :stage_interested_teaching)
        submit_select_step("Maths", :subject_interested_teaching)
        submit_date_of_birth_step(Date.new(1974, 3, 16))
        submit_choice_step("No", :citizenship)
        submit_choice_step("Not sure", :visa_status)
        submit_choice_step("Outside of the UK", :location)
        submit_select_step("Barbados", :overseas_country)
        submit_overseas_telephone_step("123456789")
        submit_review_answers_step
        expect(page).to have_text("you're signed up")

        expect(page).to have_css "#teacher-training-degree-status[data-id=222750006]", visible: false
        expect(page).to have_css "#teacher-training-degree-country[data-id='72f5c2e6-74f9-e811-a97a-000d3a2760f2']", visible: false
        expect(page).to have_css "#teacher-training-citizenship[data-id=222750001]", visible: false
        expect(page).to have_css "#teacher-training-situation[data-id=222750005]", visible: false
        expect(page).to have_css "#teacher-training-visa-status[data-id=222750002]", visible: false
        expect(page).to have_css "#teacher-training-location[data-id=222750001]", visible: false
      end

      it "studying for degree (final year), overseas and telephone" do
        submit_choice_step("No", :returning_teacher)
        submit_graduation_year_step(2021)
        submit_choice_step("The UK", :degree_country)
        submit_fill_in_step("What subject is your degree?", "Physics", :what_subject_degree)
        submit_choice_step("First-class honours", :what_degree_class)
        submit_choice_step("Exploring options for my first career", :life_stage)
        submit_choice_step("Primary", :stage_interested_teaching)
        submit_choice_step("No", :gcse_maths_english)
        submit_choice_step("Yes", :retake_gcse_maths_english)
        submit_choice_step("Yes", :gcse_science)
        submit_choice_step("2021", :start_teacher_training)
        submit_date_of_birth_step(Date.new(1974, 3, 16))
        submit_choice_step("No", :citizenship)
        submit_choice_step("Not sure", :visa_status)
        submit_choice_step("Outside of the UK", :location)
        submit_select_step("Barbados", :overseas_country)
        submit_overseas_telephone_step("123456789")
        submit_review_answers_step
        expect(page).to have_text("you're signed up")

        expect(page).to have_css "#teacher-training-degree-status[data-id=222750006]", visible: false
        expect(page).to have_css "#teacher-training-degree-country[data-id='72f5c2e6-74f9-e811-a97a-000d3a2760f2']", visible: false
        expect(page).to have_css "#teacher-training-citizenship[data-id=222750001]", visible: false
        expect(page).to have_css "#teacher-training-situation[data-id=222750002]", visible: false
        expect(page).to have_css "#teacher-training-visa-status[data-id=222750002]", visible: false
        expect(page).to have_css "#teacher-training-location[data-id=222750001]", visible: false
      end

      it "equivalent degree, lives in uk, book callback" do
        submit_choice_step("No", :returning_teacher)
        submit_choice_step("Yes", :degree_status)
        submit_choice_step("Another Country", :degree_country)
        submit_date_of_birth_step(Date.new(1974, 3, 16))
        submit_choice_step("In the UK", :location)
        submit_uk_callback_step("123456789", "1:00pm to 1:30pm")
        submit_review_answers_step
        expect(page).to have_text("we'll call you")

        expect(page).to have_css "#teacher-training-degree-status[data-id=222750000]", visible: false
        expect(page).to have_css "#teacher-training-degree-country[data-id='6f9e7b81-e44d-f011-877a-00224886d23e']", visible: false
        expect(page).to have_css "#teacher-training-location[data-id=222750000]", visible: false
      end

      it "equivalent degree, lives overseas, book callback" do
        submit_choice_step("No", :returning_teacher)
        submit_choice_step("Yes", :degree_status)
        submit_choice_step("Another Country", :degree_country)
        submit_date_of_birth_step(Date.new(1974, 3, 16))
        submit_choice_step("Outside of the UK", :location)
        submit_select_step("China", :overseas_country)
        submit_overseas_time_zone_step("447584736574", "(GMT-04:00) Caracas")
        submit_select_step("9:00am to 9:30am", :overseas_callback)
        submit_review_answers_step
        expect(page).to have_text("we'll call you")

        expect(page).to have_css "#teacher-training-degree-status[data-id=222750000]", visible: false
        expect(page).to have_css "#teacher-training-degree-country[data-id='6f9e7b81-e44d-f011-877a-00224886d23e']", visible: false
        expect(page).to have_css "#teacher-training-location[data-id=222750001]", visible: false
      end
    end
  end

  context "with an existing candidate" do
    let(:candidate_identity) { existing_candidate_identity }

    it "returning, existing data, change address" do
      submit_verification_code(candidate_identity)
      submit_choice_step("Yes", :returning_teacher)
      submit_choice_step("Yes", :paid_teaching_experience_in_uk)

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

      submit_choice_step("Yes", :citizenship)
      submit_choice_step("In the UK", :location)

      expect_current_step(:uk_address)
      expect(find_field("What's your postcode?").value).to eq("KY9 6NJ")

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
        submit_choice_step("Yes", :degree_status)
        submit_choice_step("The UK", :degree_country)

        expect_current_step(:what_subject_degree)
        expect(page.find_field("What subject is your degree?").value).to eql("Mathematics")
        click_on_continue

        expect_current_step(:what_degree_class)
        expect(page).to have_checked_field("First-class honours")
        click_on_continue

        expect_current_step(:life_stage)
        submit_choice_step("Graduated and exploring my career options", :life_stage)

        expect_current_step(:stage_interested_teaching)
        expect(page.find_field("Secondary")).to be_checked
        click_on_continue

        expect_current_step(:gcse_maths_english)
        expect(page.find_field("Yes")).to be_checked
        click_on_continue

        expect_current_step(:subject_interested_teaching)
        expect(page).to have_select("Select the subject you're most interested in teaching", selected: "Physics")
        click_on_continue

        expect_current_step(:start_teacher_training)
        expect(page.find_field("Not sure")).to be_checked
        click_on_continue

        expect_current_step(:date_of_birth)
        expect(find_field("Day").value).to eq("22")
        expect(find_field("Month").value).to eq("3")
        expect(find_field("Year").value).to eq("1987")
        click_on_continue

        submit_choice_step("No", :citizenship)
        submit_choice_step("Not sure", :visa_status)
        submit_choice_step("Outside of the UK", :location)

        expect_current_step(:overseas_country)
        expect(page).to have_select("Which country do you live in?", selected: "Bahamas")
        submit_select_step("Brazil", :overseas_country)

        submit_review_answers_step
      end
    end
  end
end
