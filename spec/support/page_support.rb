shared_context "use fixture markdown pages" do
  let(:md_files) { "#{file_fixture_path}/markdown_content" }
  let(:frontmatter) { Pages::Frontmatter.new md_files }
  before { allow(Pages::Frontmatter).to receive(:instance).and_return frontmatter }
end

shared_context "always render testing page" do
  let(:template) { "testing/markdown_test" }
  let(:page) { double Pages::Page, template: template }
  before { allow(Pages::Page).to receive(:find).and_return page }
end
