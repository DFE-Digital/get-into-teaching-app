module MailingListHelper
  def high_commitment?(consideration_journey_stage: consideration_journey_stage_id)
    consideration_journey_stage == Crm::OptionSet.lookup_by_key(:consideration_journey_stage, :i_m_very_sure_and_think_i_ll_apply)
  end

  def low_commitment?(consideration_journey_stage: consideration_journey_stage_id)
    consideration_journey_stage == Crm::OptionSet.lookup_by_key(:consideration_journey_stage, :it_s_just_an_idea)
  end

  def graduate?(degree_status: degree_status_id)
    degree_status == Crm::OptionSet.lookup_by_key(:degree_status, :graduate_or_postgraduate)
  end

  def studying?(degree_status: degree_status_id)
    degree_status == Crm::OptionSet.lookup_by_key(:degree_status, :not_yet_i_m_studying_for_one)
  end

  def no_degree?(degree_status: degree_status_id)
    degree_status == Crm::OptionSet.lookup_by_key(:degree_status, :i_don_t_have_a_degree_and_am_not_studying_for_one)
  end

  def degree_status_id
    session.dig("mailinglist", "degree_status_id")
  end

  def consideration_journey_stage_id
    session.dig("mailinglist", "consideration_journey_stage_id")
  end
end
