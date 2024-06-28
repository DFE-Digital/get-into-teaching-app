class CallsToAction::Promo::LeftSection < ViewComponent::Base
  attr_reader :classes

  def initialize(classes: [])
    @classes = classes

    super
  end

  def wrapper_classes
    (classes + %w[promo__left]).join(" ")
  end
end
