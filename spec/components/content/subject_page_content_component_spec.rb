require "rails_helper"

describe Content::SubjectPageContentComponent, type: :component do
  let(:subject_name) { "chemistry" }
  let(:component) { described_class.new(subject_name: subject_name) }
  let(:salary_value) { YAML.load_file("config/values/salaries.yml").dig("salaries", "starting", "minshortened") }

  subject do
    render_inline(component)
    page
  end

  it { is_expected.to have_css("div.subject-benefits") }
  it { is_expected.to have_css("ul li", count: 4) }
  it { is_expected.to have_link("competitive salary", href: "/life-as-a-teacher/pay-and-benefits/teacher-pay") }
  it { is_expected.to have_link("generous and secure pension", href: "/life-as-a-teacher/pay-and-benefits/teachers-pension-scheme") }
  it { is_expected.to have_text(subject_name) }
  it { is_expected.to have_content(salary_value) }

  context "when no subject name is provided" do
    let(:subject_name) { nil }

    it { expect { subject }.to raise_error(ArgumentError, "subject_name must be present") }
  end
end
