class CallsToAction::Promo::RightSection < ViewComponent::Base
  attr_reader :caption, :heading

  def initialize(caption:, heading:)
    @caption = caption
    @heading = heading

    super
  end
end
