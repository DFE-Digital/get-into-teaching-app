require "rails_helper"

describe Content::SubjectPageContentComponent, type: :component do
  let(:subject_name) { "chemistry" } # This is the subject name that we will use to test the component
  let(:component) { described_class.new(subject_name: subject_name) } # This is the component that we are testing (it takes a subject_name as an argument)
  let(:substituted_name) { "art" } # This is the name that we will substitute the subject_name with

  # Sets up the mocks for the `substitute_values` method to return the correct value
  before do
    # Mock the `substitute_values` method to return a specific value for the subject_name (this will help test that the subject name can be substituted)
    allow_any_instance_of(ContentHelper).to receive(:substitute_values).with(subject_name).and_return(substituted_name)
    # Mock substitute_values to return the default value when no subject_name is provided
    allow_any_instance_of(ContentHelper).to receive(:substitute_values).with("a subject").and_return("a subject")
    # Render the component with the subject_name by default
    render_inline(component)
  end

  context "when rendering the component" do
    it "renders the component with the correct structure and content" do
      # Test that the main container has the correct class
      expect(page).to have_css("div.subject-benefits")
      # Test that the list items are rendered correctly
      expect(page).to have_css("ul li", count: 4)
      # Test that the links are correct
      expect(page).to have_link("competitive salary", href: "/life-as-a-teacher/pay-and-benefits/teacher-pay")
      expect(page).to have_link("generous and secure pension", href: "/life-as-a-teacher/pay-and-benefits/teachers-pension-scheme")
    end
  end

  context "when changing the subject name" do
    it "substitutes the subject name on line 1 and renders correctly in the output" do
      # Test that the substituted name is rendered correctly
      expect(page).to have_content(substituted_name)
      # Verify that the substituted subject name appears in the output
      expect(page).to have_text(substituted_name.to_s)
    end
  end

  context "when no subject name is provided" do
    it "uses a default subject name and renders correctly in the output" do
      # Render the component without a subject_name
      render_inline(described_class.new)
      # Test that the default subject name is rendered correctly
      expect(page).to have_content("a subject")
      # Verify that the default subject name appears in the output
      expect(page).to have_text("a subject")
    end
  end

  context "when rendering the salary value" do
    it "renders the salary in either full numeric or shorthand format" do
      # Check for either full numeric or 'k' shorthand format
      expect(page).to have_content(/£\d{1,3}(,\d{3})?k?/)
    end
  end
end
