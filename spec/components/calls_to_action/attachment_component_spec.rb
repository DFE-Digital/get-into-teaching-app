require "rails_helper"

RSpec.describe CallsToAction::AttachmentComponent, type: :component do
  let(:basic_args) do
    {
      text: "Lorem ipsum ....",
      file_path: "media/documents/ICT_skills_audit_returners.pdf",
    }
  end

  let(:args) { basic_args }

  subject do
    render_inline described_class.new(args)
    page
  end

  specify "renders the component" do
    is_expected.to have_css(".attachment")
  end

  context "with the basic arguments" do
    specify "includes a link to the attachment" do
      is_expected.to have_css(%(a[href*="packs-test/media/documents/ICT_skills_audit_returners"]))
    end

    specify "includes the text in the link" do
      is_expected.to have_link(args[:text], class: "call-to-action-icon-button")
    end

    specify "the file icon is not visible" do
      is_expected.not_to have_css(".fas.fa-file-pdf")
    end
  end

  context "with all the arguments" do
    let(:optional_args) do
      {
        file_type: "PDF",
        file_size: "160KB",
        published_at: "15 May 2019",
        updated_at: "20 July 2020",
      }
    end

    let(:args) do
      basic_args.merge(optional_args)
    end

    specify "the file icon is visible" do
      is_expected.to have_css(".fas.fa-file-pdf")
    end

    specify "the link text includes the file description" do
      is_expected.to have_link("#{args[:text]} (#{args[:file_type]} #{args[:file_size]})", class: "call-to-action-icon-button")
    end

    specify "includes the file size" do
      is_expected.to have_text(args[:file_size])
    end

    specify "includes the file type" do
      is_expected.to have_content(args[:file_type])
    end

    specify "includes the published date" do
      is_expected.to have_content("Published #{args[:published_at]}")
    end

    specify "includes the updated date" do
      is_expected.to have_content("Last updated #{args[:updated_at]}")
    end
  end
end
