require "rails_helper"

describe "Lazy Load Images", type: :request do
  subject { response.body }

  before do
    get root_path
  end

  it { is_expected.to include("data-src") }
  it { is_expected.to include("lazyload") }
end
