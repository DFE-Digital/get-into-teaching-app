module WelcomeHelper
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
      "Especially as you get closer to graduating."
    else
      "Now's a great time to make the move"
    end
  end

  def degree_status_id
    session.dig("welcome_guide", "degree_status_id") || session.dig("mailinglist", "degree_status_id")
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
    subject = GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS.invert[uuid]

    return if subject.blank?

    return subject if leave_capitalised || uuid.in?([
      "942655a1-2afa-e811-a981-000d3a276620", # English
      "962655a1-2afa-e811-a981-000d3a276620", # French
      "9c2655a1-2afa-e811-a981-000d3a276620", # German
      "b82655a1-2afa-e811-a981-000d3a276620", # Spanish
    ])

    subject.downcase
  end
end
