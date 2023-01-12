class CallsToAction::Promo::PromoComponent < ViewComponent::Base
  renders_one :left_section, CallsToAction::Promo::LeftSection
  renders_one :right_section, CallsToAction::Promo::RightSection

  attr_reader :border, :reverse

  def initialize(border: :top, reverse: false)
    super

    @border = border
    @reverse = reverse
  end

  def classes
    ["promo", "promo--border-#{border}"].tap do |c|
      c << "promo--reverse" if reverse
    end
  end
end
