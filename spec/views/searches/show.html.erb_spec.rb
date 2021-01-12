require "rails_helper"

describe "searches/show.html.erb" do
  before { render }
  subject { rendered }

  it { is_expected.to have_css "h1" }
end
