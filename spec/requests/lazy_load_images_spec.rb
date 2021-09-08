require "rails_helper"

describe "Lazy Load Images", type: :request do
  before do
    get root_path
  end

  subject { response.body }

  it { is_expected.to include("data-src") }
  it { is_expected.to include("lazyload") }
end
