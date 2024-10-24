require "rails_helper"

describe "_benefits.html.erb" do
  let(:subject_name) { "chemistry" }
  let(:salary_value) { YAML.load_file("config/values/salaries.yml").dig("salaries", "starting", "minshortened") }

  subject do
    assign(:front_matter, { "subject" => subject_name })
    assign(:salaries_starting_minshortened, "£31k")
    render partial: "content/shared/teaching/benefits"
    rendered
  end

  it { is_expected.to have_css("ul li") }
  it { is_expected.to have_link("competitive salary starting at", href: "/life-as-a-teacher/pay-and-benefits/teacher-pay") }
  it { is_expected.to have_link("generous and secure pension", href: "/life-as-a-teacher/pay-and-benefits/teachers-pension-scheme") }
  it { is_expected.to have_text(subject_name) }
  it { is_expected.to have_text(salary_value) }
end
