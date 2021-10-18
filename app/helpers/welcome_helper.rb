module WelcomeHelper
  def greeting
    if (first_name = session.dig("mailinglist", "first_name"))
      "Hey #{first_name}"
    else
      "Hello"
    end
  end

  def teaching_subject
    subject_id = session.dig("mailinglist", "preferred_teaching_subject_id")

    if (subject = retrrieve_subject(subject_id))
      safe_join(["teaching", tag.mark("#{subject}.")], " ")
    else
      tag.mark("teaching.")
    end
  end

  def degree_stage_based_encouragement
    degree_stage_id = session.dig("mailinglist", "degree_status_id")

    # degree stage:         final year , second year
    if degree_stage_id.in?([222_750_001, 222_750_002])
      "Especially as you get closer to graduating."
    else
      "Now's a great time to make the move"
    end
  end

private

  # return the subject name from its uuid, downcasing all except
  # proper nouns
  def retrrieve_subject(uuid)
    subject = GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS.invert[uuid]

    return if subject.blank?

    return subject if uuid.in?([
      "942655a1-2afa-e811-a981-000d3a276620", # English
      "962655a1-2afa-e811-a981-000d3a276620", # French
      "9c2655a1-2afa-e811-a981-000d3a276620", # German
      "b82655a1-2afa-e811-a981-000d3a276620", # Spanish
    ])

    subject.downcase
  end
end
