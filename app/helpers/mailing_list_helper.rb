module MailingListHelper
  def ml_high_commitment?(consideration_journey_stage: ml_consideration_journey_stage_id)
    consideration_journey_stage == Crm::OptionSet.lookup_by_key(:consideration_journey_stage, :i_m_very_sure_and_think_i_ll_apply)
  end

  def ml_low_commitment?(consideration_journey_stage: ml_consideration_journey_stage_id)
    consideration_journey_stage == Crm::OptionSet.lookup_by_key(:consideration_journey_stage, :it_s_just_an_idea)
  end

  def ml_graduate?(degree_status: ml_degree_status_id)
    degree_status == Crm::OptionSet.lookup_by_key(:degree_status, :graduate_or_postgraduate)
  end

  def ml_studying?(degree_status: ml_degree_status_id)
    degree_status == Crm::OptionSet.lookup_by_key(:degree_status, :not_yet_i_m_studying_for_one)
  end

  def ml_no_degree?(degree_status: ml_degree_status_id)
    degree_status == Crm::OptionSet.lookup_by_key(:degree_status, :i_don_t_have_a_degree_and_am_not_studying_for_one)
  end

  def ml_degree_status_id
    session.dig("mailinglist", "degree_status_id")
  end

  def ml_consideration_journey_stage_id
    session.dig("mailinglist", "consideration_journey_stage_id")
  end
end
