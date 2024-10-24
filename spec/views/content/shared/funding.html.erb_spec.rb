require "rails_helper"

describe "_funding.html.erb" do
  let(:subject_name) { "chemistry" }
  let(:salary_value) { YAML.load_file("config/values/salaries.yml").dig("burseries", "postgraduate", "chemistry") }

  subject do
    assign(:front_matter, { "subject" => subject_name })
    assign(:bursaries_postgraduate_chemistry, "£25,000")
    assign(:scholarships_chemistry, "£10,000")
    render partial: "content/shared/teaching/funding"
    rendered
  end

  it { is_expected.to have_css("ul li") }
  it { is_expected.to have_link("extra funding and support", href: "/funding-and-support") }
  it { is_expected.to have_link("Tax-free bursaries of", href: "/funding-and-support/scholarships-and-bursaries") }
  it { is_expected.to have_text(subject_name) }
  it { is_expected.to have_text(salary_value) }
end
