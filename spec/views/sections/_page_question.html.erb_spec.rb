require "rails_helper"

describe "sections/_page_question.html.erb", type: :view do
  before { render partial: "sections/page_question" }
  subject { rendered }

  # Targetted by GTM event.
  it { is_expected.to match(/class=\"page-question__answer\".*>Yes</) }
  it { is_expected.to match(/class=\"page-question__answer\".*>No</) }
end
