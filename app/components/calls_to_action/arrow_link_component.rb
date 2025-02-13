# frozen_string_literal: true

class CallsToAction::ArrowLinkComponent < ViewComponent::Base
  attr_reader :link_target, :link_text

  def initialize(link_target:, link_text:)
    super

    @link_target = link_target
    @link_text = link_text
  end
end
