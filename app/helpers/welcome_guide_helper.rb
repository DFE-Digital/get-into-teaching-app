module WelcomeGuideHelper
  # Contains logic that we'll used to decide what 'mode' the Welcome Guide will
  # be shown in. The intention is for it to contain custom content for
  # candidates who meet certain critera - e.g., a Maths final year student
  class WelcomeGuideModeSelector
    attr_reader :consideration_journey_stage_id, :preferred_teaching_subject, :commitment_level, :degree_status_id

    def initialize(mailing_list_session = {})
      @commitment_level               = mailing_list_session["commitment_level"]
      @consideration_journey_stage_id = mailing_list_session["consideration_journey_stage_id"]
      @degree_status_id               = mailing_list_session["degree_status_id"]
      @preferred_teaching_subject     = mailing_list_session["preferred_teaching_subject"]
    end

    # Variations to be supplied by Havas:
    #
    # * Maths, final year student
    # * Maths, graduate
    # * Science, final year student
    # * Science, graduate
    # * MFL, final year student
    # * MFL, graduate
    # * English, final year student
    # * English, graduate
    # * Generic, final year student
    # * Generic, graduate
    def mode
      case
      when maths? && final_year_student?
        :maths_final_year
      when maths? && graduate?
        :maths_graduate

      when science? && final_year_student?
        :science_final_year
      when science? && graduate?
        :science_graduate

      when mfl? && final_year_student?
        :mfl_final_year
      when mfl? && graduate?
        :mfl_graduate

      when english? && final_year_student?
        :english_final_year
      when english? && graduate?
        :english_graduate

      when final_year_student?
        :generic_final_year
      when graduate?
        :generic_graduate

      else
        :generic
      end
    end

  private

    def final_year_student?
      degree_status_id.in?(degree_status_codes("Final year"))
    end

    def graduate?
      degree_status_id.in?(degree_status_codes("Graduate or postgraduate"))
    end

    def mfl?
      preferred_teaching_subject.in?(subject_codes("French", "German", "Languages (other)", "Spanish"))
    end

    def english?
      preferred_teaching_subject.in?(subject_codes("English"))
    end

    def science?
      preferred_teaching_subject.in?(subject_codes("Biology", "Chemistry", "General science", "Physics", "Physics with maths"))
    end

    def maths?
      preferred_teaching_subject.in?(subject_codes("Maths"))
    end

    def degree_status_codes(*names)
      GetIntoTeachingApiClient::Constants::DEGREE_STATUS_OPTIONS.values_at(*names)
    end

    def subject_codes(*names)
      GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS.values_at(*names)
    end
  end

  def welcome_guide_mode(...)
    WelcomeGuideModeSelector.new(...).mode
  end
end
