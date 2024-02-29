module TeacherTrainingAdviser
  class Wizard < ::GITWizard::Base
    UK_COUNTRY_ID = "72f5c2e6-74f9-e811-a97a-000d3a2760f2".freeze
    ATTRIBUTES_TO_LEAVE = %w[
      first_name
      type_id
      degree_options
      sub_channel_id
      callback_offered
    ].freeze

    self.steps = [
      Steps::Identity,
      GITWizard::Steps::Authenticate,
      Steps::AlreadySignedUp,
      Steps::ReturningTeacher,
      Steps::HasTeacherId,
      Steps::PreviousTeacherId,
      Steps::StageTaught,
      Steps::SubjectTaught,
      Steps::HaveADegree,
      Steps::NoDegree,
      Steps::StageOfDegree,
      Steps::WhatSubjectDegree,
      Steps::WhatDegreeClass,
      Steps::StageInterestedTeaching,
      Steps::GcseMathsEnglish,
      Steps::RetakeGcseMathsEnglish,
      Steps::GcseScience,
      Steps::RetakeGcseScience,
      Steps::QualificationRequired,
      Steps::SubjectInterestedTeaching,
      Steps::StartTeacherTraining,
      Steps::SubjectLikeToTeach,
      Steps::DateOfBirth,
      Steps::UkOrOverseas,
      Steps::UkAddress,
      Steps::UkTelephone,
      Steps::OverseasCountry,
      Steps::OverseasTelephone,
      Steps::UkCallback,
      Steps::OverseasTimeZone,
      Steps::OverseasCallback,
      Steps::ReviewAnswers,
    ].freeze

    def matchback_attributes
      %i[candidate_id qualification_id adviser_status_id].freeze
    end

    def time_zone
      find(Steps::OverseasTimeZone.key).time_zone || "London"
    end

    def complete!
      return false unless super

      sign_up_candidate

      @store.prune!(leave: ATTRIBUTES_TO_LEAVE)
    end

    def exchange_access_token(timed_one_time_password, request)
      @api ||= GetIntoTeachingApiClient::TeacherTrainingAdviserApi.new
      @api.exchange_access_token_for_teacher_training_adviser_sign_up(timed_one_time_password, request)
    end

    def export_data
      super.tap do |export|
        default_country(export)
        default_itt_year(export)
      end
    end

  private

    def sign_up_candidate
      attributes = GetIntoTeachingApiClient::TeacherTrainingAdviserSignUp.attribute_map.keys
      data = export_data.slice(*attributes.map(&:to_s))
      request = GetIntoTeachingApiClient::TeacherTrainingAdviserSignUp.new(data)
      api = GetIntoTeachingApiClient::TeacherTrainingAdviserApi.new
      api.sign_up_teacher_training_adviser_candidate(request)
    end

    def default_country(export)
      # Default country_id to be UK if applicable
      export["country_id"] = UK_COUNTRY_ID if find("uk_or_overseas").uk?
    end

    def default_itt_year(export)
      itt_step = find("start_teacher_training")
      export["initial_teacher_training_year_id"] ||= itt_step.inferred_year_id
    end
  end
end
