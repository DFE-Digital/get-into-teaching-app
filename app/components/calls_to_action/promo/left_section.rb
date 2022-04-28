class CallsToAction::Promo::LeftSection < ViewComponent::Base
  attr_reader :caption, :heading, :link_text, :link_target

  def initialize(heading:, caption: nil, link_text: nil, link_target: nil)
    @caption = caption
    @heading = heading
    @link_text = link_text
    @link_target = link_target

    super
  end
end
