class CallsToAction::Promo::PromoComponent < ViewComponent::Base
  renders_one :left_section, CallsToAction::Promo::LeftSection
  renders_one :right_section, CallsToAction::Promo::RightSection
end
