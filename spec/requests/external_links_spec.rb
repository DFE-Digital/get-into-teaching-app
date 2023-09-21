require "rails_helper"

describe "External Links", type: :request do
  subject { response.body }

  before do
    get "/is-teaching-right-for-me/get-school-experience"
  end

  it do
    is_expected.to include(
      %{<a href="https://schoolexperience.education.gov.uk/">school experience<span class="visually-hidden">(opens in new window)</span></a>},
    )
  end
end
