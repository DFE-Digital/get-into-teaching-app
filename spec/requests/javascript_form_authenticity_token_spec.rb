require "rails_helper"

describe "Javascript form authenticity token" do
  before { get root_path }
  subject { response.body }
  it { is_expected.to match(/window\._token = '.{88}'/) }
end
