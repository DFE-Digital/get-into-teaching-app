require "rails_helper"

RSpec.describe CallsToAction::NarrowComponent, type: :component do
  subject do
    CallsToAction::NarrowComponent.new(
      icon: "icon-question",
      title: "title",
      text: "text",
      link_text: "link_text",
      link_target: "/link_target",
    )
  end

  it { is_expected.to be_a_kind_of(CallsToAction::SimpleComponent) }
end
