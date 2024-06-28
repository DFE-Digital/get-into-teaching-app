module MailingListHelper
  def have_degree_low_commitment?(degree_status: degree_status_id, consideration_journey_stage: consideration_journey_stage_id)
    degree_status.in?(gradudate_or_postgraduate) && consideration_journey_stage.in?(low_commitment)
  end

  def have_degree_high_commitment?(degree_status: degree_status_id, consideration_journey_stage: consideration_journey_stage_id)
    degree_status.in?(gradudate_or_postgraduate) && consideration_journey_stage.in?(high_commitment)
  end

  def final_year_low_commitment?(degree_status: degree_status_id, consideration_journey_stage: consideration_journey_stage_id)
    degree_status.in?(final_year) && consideration_journey_stage.in?(low_commitment)
  end

  def final_year_high_commitment?(degree_status: degree_status_id, consideration_journey_stage: consideration_journey_stage_id)
    degree_status.in?(final_year) && consideration_journey_stage.in?(high_commitment)
  end

  def first_or_second_year_low_commitment?(degree_status: degree_status_id, consideration_journey_stage: consideration_journey_stage_id)
    degree_status.in?(first_or_second_year) && consideration_journey_stage.in?(low_commitment)
  end

  def first_or_second_year_high_commitment?(degree_status: degree_status_id, consideration_journey_stage: consideration_journey_stage_id)
    degree_status.in?(first_or_second_year) && consideration_journey_stage.in?(high_commitment)
  end

  def no_degree_low_commitment?(degree_status: degree_status_id, consideration_journey_stage: consideration_journey_stage_id)
    degree_status.in?(no_degree) && consideration_journey_stage.in?(low_commitment)
  end

  def no_degree_high_commitment?(degree_status: degree_status_id, consideration_journey_stage: consideration_journey_stage_id)
    degree_status.in?(no_degree) && consideration_journey_stage.in?(high_commitment)
  end

  def other_low_commitment?(degree_status: degree_status_id, consideration_journey_stage: consideration_journey_stage_id)
    degree_status.in?(other) && consideration_journey_stage.in?(low_commitment)
  end

  def other_high_commitment?(degree_status: degree_status_id, consideration_journey_stage: consideration_journey_stage_id)
    degree_status.in?(other) && consideration_journey_stage.in?(high_commitment)
  end

  def other
    Crm::OptionSet.lookup_by_keys(:degree_status, :other)
  end

  def no_degree
    Crm::OptionSet.lookup_by_keys(:degree_status, :i_don_t_have_a_degree_and_am_not_studying_for_one)
  end

  def first_or_second_year
    Crm::OptionSet.lookup_by_keys(:degree_status, :first_year, :second_year)
  end

  def final_year
    Crm::OptionSet.lookup_by_keys(:degree_status, :final_year)
  end

  def gradudate_or_postgraduate
    Crm::OptionSet.lookup_by_keys(:degree_status, :graduate_or_postgraduate)
  end

  def low_commitment
    Crm::OptionSet.lookup_by_keys(
      :consideration_journey_stage,
      :it_s_just_an_idea,
      :i_m_not_sure_and_finding_out_more,
    )
  end

  def high_commitment
    Crm::OptionSet.lookup_by_keys(
      :consideration_journey_stage,
      :i_m_fairly_sure_and_exploring_my_options,
      :i_m_very_sure_and_think_i_ll_apply,
    )
  end
end
