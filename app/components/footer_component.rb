class FooterComponent < ViewComponent::Base
  def initialize(talk_to_us: true)
    super

    @talk_to_us = talk_to_us
  end

  def talk_to_us?
    @talk_to_us
  end
end
