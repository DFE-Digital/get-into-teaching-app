require "rails_helper"

describe "_funding.html.erb" do
  let(:subject_name) { "chemistry" }
  let(:veteran_status) { "true" }
  let(:salary_value) { YAML.load_file("config/values/salaries.yml").dig("burseries", "postgraduate", "chemistry") }

  subject do
    assign(:front_matter, { "subject" => subject_name, "veteran" => veteran_status })
    assign(:bursaries_postgraduate_chemistry, "£25,000")
    assign(:scholarships_chemistry, "£10,000")
    render partial: "content/partials/teaching/funding"
    rendered
  end

  it { is_expected.to have_css("ul li") }
  it { is_expected.to have_link("extra funding and support", href: "/funding-and-support") }
  it { is_expected.to have_text(subject_name) }
  it { is_expected.to have_text(salary_value) }
  it { is_expected.to include("a veteran") }

  context "when veteran status is false" do
    let(:veteran_status) { false }

    it { is_expected { subject }.not_to include("a veteran") }
  end
end
