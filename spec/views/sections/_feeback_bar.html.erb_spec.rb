require "rails_helper"

describe "sections/_feedback_bar.html.erb", type: :view do
  before { render partial: "sections/feedback_bar" }
  subject { rendered }

  it { is_expected.to have_link("Tell us what you think.") }

  # Targetted by GTM event.
  it { is_expected.to match(/class=\"page-question__answer strong\".*>Yes</) }
  it { is_expected.to match(/class=\"page-question__answer strong\".*>No</) }
end
