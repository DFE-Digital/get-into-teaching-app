class FooterComponent < ViewComponent::Base
  attr_reader :lid_pixel_event

  def initialize(talk_to_us: true, feedback: true, mailing_list: true, lid_pixel_event: nil)
    super

    @talk_to_us      = talk_to_us
    @feedback        = feedback
    @mailing_list    = mailing_list
    @lid_pixel_event = lid_pixel_event
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
