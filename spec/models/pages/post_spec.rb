require "rails_helper"

RSpec.describe ::Pages::Post do
  let(:instance) { described_class.new("/blog/post", frontmatter) }

  describe "#validate!" do
    let(:frontmatter) { { tags: %w[benefits] } }

    subject(:validate) { instance.validate! }

    it { expect { validate }.not_to raise_error }

    context "when the post has invalid tags" do
      let(:frontmatter) { { tags: %w[invalid] } }

      it "raises an error" do
        expected_attrs = { message: "These tags are not defined in tags.yml: invalid", anchor: "#tags" }
        expect { validate }.to raise_error(
          an_instance_of(Pages::ContentError).and(having_attributes(expected_attrs)),
        )
      end
    end
  end
end
