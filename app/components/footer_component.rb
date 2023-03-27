class FooterComponent < ViewComponent::Base
  def initialize(talk_to_us: true, feedback: true)
    super

    @talk_to_us = talk_to_us
    @feedback = feedback
  end

  def talk_to_us?
    @talk_to_us
  end

  def feedback?
    @feedback
  end

  def mailing_list?
    @mailing_list
  end
end
