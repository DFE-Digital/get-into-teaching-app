require "rails_helper"

def subject_code(name)
  GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS.fetch(name)
end

def degree_status_code(name)
  GetIntoTeachingApiClient::Constants::DEGREE_STATUS_OPTIONS.fetch(name)
end

RSpec.describe WelcomeGuideHelper, type: :helper do
  describe "#welcome_guide_mode" do
    final_year = "Final year"
    graduate = "Graduate or postgraduate"

    [
      # MATHS

      OpenStruct.new(
        mode: :maths_graduate,
        description: "Maths, graduate",
        store: {
          "preferred_teaching_subject" => subject_code("Maths"),
          "degree_status_id" => degree_status_code(graduate),
        },
      ),
      OpenStruct.new(
        mode: :maths_final_year,
        description: "Maths, final year student",
        store: {
          "preferred_teaching_subject" => subject_code("Maths"),
          "degree_status_id" => degree_status_code(final_year),
        },
      ),

      # SCIENCE

      OpenStruct.new(
        mode: :science_graduate,
        description: "Biology, graduate",
        store: {
          "preferred_teaching_subject" => subject_code("Biology"),
          "degree_status_id" => degree_status_code(graduate),
        },
      ),

      OpenStruct.new(
        mode: :science_graduate,
        description: "Chemistry, graduate",
        store: {
          "preferred_teaching_subject" => subject_code("Chemistry"),
          "degree_status_id" => degree_status_code(graduate),
        },
      ),

      OpenStruct.new(
        mode: :science_final_year,
        description: "Physics, final year",
        store: {
          "preferred_teaching_subject" => subject_code("Physics"),
          "degree_status_id" => degree_status_code(final_year),
        },
      ),

      OpenStruct.new(
        mode: :science_final_year,
        description: "Physics with maths, final year",
        store: {
          "preferred_teaching_subject" => subject_code("Physics with maths"),
          "degree_status_id" => degree_status_code(final_year),
        },
      ),

      # English

      OpenStruct.new(
        mode: :english_graduate,
        description: "English, graduate",
        store: {
          "preferred_teaching_subject" => subject_code("English"),
          "degree_status_id" => degree_status_code(graduate),
        },
      ),

      OpenStruct.new(
        mode: :english_final_year,
        description: "English, final year",
        store: {
          "preferred_teaching_subject" => subject_code("English"),
          "degree_status_id" => degree_status_code(final_year),
        },
      ),

      # MFL

      OpenStruct.new(
        mode: :mfl_final_year,
        description: "French, final year",
        store: {
          "preferred_teaching_subject" => subject_code("French"),
          "degree_status_id" => degree_status_code(final_year),
        },
      ),

      OpenStruct.new(
        mode: :mfl_final_year,
        description: "German, final year",
        store: {
          "preferred_teaching_subject" => subject_code("German"),
          "degree_status_id" => degree_status_code(final_year),
        },
      ),

      OpenStruct.new(
        mode: :mfl_graduate,
        description: "Languages (other), graduate",
        store: {
          "preferred_teaching_subject" => subject_code("Languages (other)"),
          "degree_status_id" => degree_status_code(graduate),
        },
      ),

      OpenStruct.new(
        mode: :mfl_graduate,
        description: "Spanish, graduate",
        store: {
          "preferred_teaching_subject" => subject_code("Spanish"),
          "degree_status_id" => degree_status_code(graduate),
        },
      ),

      # Generic

      OpenStruct.new(
        mode: :generic_graduate,
        description: "Generic, graduate",
        store: {
          "degree_status_id" => degree_status_code(graduate),
        },
      ),

      OpenStruct.new(
        mode: :generic_final_year,
        description: "Generic, final year",
        store: {
          "degree_status_id" => degree_status_code(final_year),
        },
      ),

      OpenStruct.new(
        mode: :generic,
        description: "Generic",
        store: {},
      ),
    ].each do |options|
      describe options.description do
        subject { welcome_guide_mode(options.store) }

        specify "returns #{options.mode}" do
          expect(subject).to eql(options.mode)
        end
      end
    end
  end
end
