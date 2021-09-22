require "rails_helper"

describe "Next Gen Images", type: :request do
  subject { response.body }

  before do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with(/.*\.svg/).and_return(true)
    get root_path
  end

  it do
    is_expected.to match(
      /<picture><source .*><img .*><noscript><img .*><\/noscript><\/picture>/,
    )
  end
end
