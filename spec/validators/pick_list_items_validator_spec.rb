require "rails_helper"

class PickListItemValidatable
  include ActiveModel::Model

  attr_accessor :item

  validates :item, pick_list_items: { method: :get_candidate_channels }
end

RSpec.describe PickListItemsValidator, type: :validator do
  subject { PickListItemValidatable.new }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
      receive(:get_candidate_channels).and_return(
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
