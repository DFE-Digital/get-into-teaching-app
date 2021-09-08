require "rails_helper"

describe "Next Gen Images", type: :request do
  before do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with(/.*\.svg/) { true }
    get root_path
  end

  subject { response.body }

  it do
    is_expected.to match(
      /<picture><source .*><\/source><img .*><noscript><img .*><\/noscript><\/picture>/,
    )
  end
end
