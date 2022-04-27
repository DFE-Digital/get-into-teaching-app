class CallsToAction::Promo::LeftSection < ViewComponent::Base
  attr_reader :caption, :heading, :link_text, :link_target

  def initialize(caption:, heading:, link_text:, link_target:)
    @caption = caption
    @heading = heading
    @link_text = link_text
    @link_target = link_target

    super
  end
end
