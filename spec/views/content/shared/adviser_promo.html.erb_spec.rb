require "rails_helper"

describe "_adviser-promo.html.erb" do
  subject do
    assign(:front_matter, { "subject" => subject_name })
    render partial: "content/shared/subject-pages/adviser-promo"
    rendered
  end

  context "when a subject starts with a consonant it renders 'a'" do
    let(:subject_name) { "chemistry" }

    it { is_expected { subject }.to include("a chemistry teacher") }
  end

  context "when a subject starts with a vowel it renders 'an'" do
    let(:subject_name) { "art" }

    it { is_expected { subject }.to include("an art teacher") }
  end
end
