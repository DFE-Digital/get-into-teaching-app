module WelcomeHelper
  def show_welcome_guide?(degree_status: degree_status_id, consideration_journey_stage: consideration_journey_stage_id)
    low_commitment?(consideration_journey_stage: consideration_journey_stage) && graduate?(degree_status: degree_status)
  end

  def high_commitment?(consideration_journey_stage: consideration_journey_stage_id)
    # I think I'll apply
    consideration_journey_stage == 222_750_003
  end

  def low_commitment?(consideration_journey_stage: consideration_journey_stage_id)
    # It's just an idea
    consideration_journey_stage == 222_750_000
  end

  def graduate?(degree_status: degree_status_id)
    # Yes
    degree_status == 222_750_000
  end

  def studying?(degree_status: degree_status_id)
    # Not yet, I'm studying for one
    degree_status == 222_750_006
  end

  def no_degree?(degree_status: degree_status_id)
    # No
    degree_status == 222_750_004
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

  def subject_teachers
    if (subject = welcome_guide_subject)
      "#{subject} teachers"
    else
      "teachers"
    end
  end

  def degree_stage_based_encouragement
    # degree stage:          final year , second year
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
    subject = Crm::TeachingSubject.lookup_by_uuid(uuid)

    return if subject.blank?

    proper_nouns = Crm::TeachingSubject.lookup_by_keys(:english, :french, :german, :spanish)

    return subject if leave_capitalised || uuid.in?(proper_nouns)

    subject.downcase
  end
end
