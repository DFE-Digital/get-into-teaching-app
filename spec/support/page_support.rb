shared_context "with fixture markdown pages" do
  let(:md_files) { "#{file_fixture_path}/markdown_content" }
  let(:frontmatter) { Pages::Frontmatter.new md_files }
  before { allow(Pages::Frontmatter).to receive(:instance).and_return frontmatter }
end
