require "rails_helper"

describe "sections/_page_helpful.html.erb", type: :view do
  before { render partial: "sections/page_helpful" }
  subject { rendered }

  # Targetted by GTM event.
  it { is_expected.to match(/class=\"page-question__answer\".*>Yes</) }
  it { is_expected.to match(/class=\"page-question__answer\".*>No</) }
end
