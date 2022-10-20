class CallsToAction::Promo::PromoComponent < ViewComponent::Base
  renders_one :left_section, CallsToAction::Promo::LeftSection
  renders_one :right_section, CallsToAction::Promo::RightSection

  attr_reader :border

  def initialize(border: :top)
    super

    @border = border
  end

  def classes
    %w[promo].tap do |c|
      c << "promo--border-#{border}"
    end
  end
end
