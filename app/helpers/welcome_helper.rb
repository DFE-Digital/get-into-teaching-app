module WelcomeHelper
  def show_welcome_guide?(degree_status = degree_status_id, consideration_journey_stage = consideration_journey_stage_id)
    gradudate_or_postgraduate = retrieve_degree_status_ids("Graduate or postgraduate")
    allowed_graduate_consideration_stages = retrieve_consideration_journey_stage_ids(
      "It’s just an idea",
      "I’m not sure and finding out more",
    )
    final_year_student = retrieve_degree_status_ids("Final year")

    degree_status.in?(final_year_student) || (
      degree_status.in?(gradudate_or_postgraduate) && consideration_journey_stage.in?(allowed_graduate_consideration_stages)
    )
  end

  def greeting
    if first_name
      "Hey #{first_name}"
    else
      "Hello"
    end
  end

  def welcome_guide_subject(leave_capitalised: false)
    retrieve_subject(welcome_guide_subject_id, leave_capitalised: leave_capitalised)
  end

  def teaching_subject(leave_capitalised: false, mark_tag: false)
    if (subject = welcome_guide_subject(leave_capitalised: leave_capitalised))
      subject_name = mark_tag ? tag.mark("#{subject}.") : "#{subject}."

      safe_join(["teaching", subject_name], " ")
    else
      mark_tag ? tag.mark("teaching.") : "teaching."
    end
  end

  def degree_stage_based_encouragement
    # degree stage:         final year , second year
    if degree_status_id.in?([222_750_001, 222_750_002])
      "Especially as you get closer to graduating"
    else
      "Now's a great time to make the move"
    end
  end

  def degree_status_id
    session.dig("welcome_guide", "degree_status_id") || session.dig("mailinglist", "degree_status_id")
  end

  def consideration_journey_stage_id
    session.dig("welcome_guide", "consideration_journey_stage_id") || session.dig("mailinglist", "consideration_journey_stage_id")
  end

  def welcome_guide_subject_id
    session.dig("welcome_guide", "preferred_teaching_subject_id") || session.dig("mailinglist", "preferred_teaching_subject_id")
  end

  def first_name
    session.dig("mailinglist", "first_name")
  end

private

  # return the subject name from its uuid, downcasing all except
  # proper nouns
  def retrieve_subject(uuid, leave_capitalised:)
    subject = TeachingSubject.lookup_by_uuid(uuid)

    return if subject.blank?

    proper_nouns = TeachingSubject.lookup_by_keys(:english, :french, :german, :spanish)

    return subject if leave_capitalised || uuid.in?(proper_nouns)

    subject.downcase
  end

  def retrieve_degree_status_ids(*names)
    GetIntoTeachingApiClient::Constants::DEGREE_STATUS_OPTIONS.values_at(*names)
  end

  def retrieve_consideration_journey_stage_ids(*names)
    GetIntoTeachingApiClient::Constants::CONSIDERATION_JOURNEY_STAGES.values_at(*names)
  end
end
