require "rails_helper"

class LookupItemValidatable
  include ActiveModel::Model

  attr_accessor :item

  validates :item, lookup_items: { method: :get_countries }
end

RSpec.describe LookupItemsValidator, type: :validator do
  subject { LookupItemValidatable.new }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::LookupItemsApi).to \
      receive(:get_countries).and_return(
        [OpenStruct.new({ id: 1, value: "one" })],
      )
  end

  it "is invalid when null" do
    expect(subject).to be_invalid
  end

  it "is valid when item in list" do
    subject.item = 1
    expect(subject).to be_valid
  end

  it "is invalid when item not in list" do
    subject.item = 2
    expect(subject).to be_invalid
  end
end
