class CallsToAction::Promo::RightSection < ViewComponent::Base
  attr_reader :caption, :heading

  def initialize(heading:, caption: nil)
    @heading = heading
    @caption = caption

    super
  end
end
