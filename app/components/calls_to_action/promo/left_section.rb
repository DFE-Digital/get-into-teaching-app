class CallsToAction::Promo::LeftSection < ViewComponent::Base
  attr_reader :caption, :heading, :link_text, :link_target, :classes

  def initialize(heading:, caption: nil, link_text: nil, link_target: nil, classes: [])
    @caption = caption
    @heading = heading
    @link_text = link_text
    @link_target = link_target
    @classes = classes

    super
  end

  def wrapper_classes
    (classes + %w[promo__left]).join(" ")
  end
end
