require "rails_helper"

describe TemplateHandlers::ERB, type: :view do
  subject { rendered }

  context "generic ERB page accessing the @sitemap" do
    let(:erb) do
      <<~ERB
        <%= pluralize(@sitemap[:markdown_content].count, "resource") %>
        <%= @sitemap[:markdown_content].map { |r| r[:path] } %>
        <%= @sitemap[:markdown_content].map { |r| r[:front_matter] } %>
      ERB
    end

    before do
      TemplateHandlers::ERB.sitemap = nil # clear cache
      stub_const("TemplateHandlers::ERB::MARKDOWN_CONTENT_DIR", "#{file_fixture_path}/markdown_content")
      stub_template "test.erb" => erb
      render template: "test.erb"
    end

    it { is_expected.to have_text("2 resources") }
    it { is_expected.to match(/\/page1/) }
    it { is_expected.to match(/\/subfolder\/page2/) }
    it { is_expected.to match(/Hello World 1/) }
    it { is_expected.to match(/Hello World 2/) }
  end
end
