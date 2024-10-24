require "rails_helper"

describe "_bursary_scholarship.html.erb" do
  let(:subject_name) { "chemistry" }
  let(:bursary_value) { YAML.load_file("config/values/bursaries.yml").dig("bursaries", "postgraduate", "chemistry") }
  let(:scholarship_value) { YAML.load_file("config/values/scholarships.yml").dig("scholarships", "chemistry") }

  subject do
    assign(:front_matter, { "subject" => subject_name })
    assign(:bursaries_postgraduate_chemistry, "£25,000")
    assign(:scholarships_chemistry, "£10,000")
    render partial: "content/shared/teaching/bursary_scholarship"
    rendered
  end

  it { is_expected.to have_link("Tax-free bursaries of", href: "/funding-and-support/scholarships-and-bursaries") }
  it { is_expected.to have_text(subject_name) }
  it { is_expected.to have_text(bursary_value) }
  it { is_expected.to have_text(scholarship_value) }
end
