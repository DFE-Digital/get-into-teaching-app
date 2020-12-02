require "rails_helper"

describe PostcodeValidator do
  class TestModel
    include ActiveModel::Model
    attr_accessor :postcode, :accept_partial_postcode
    validates :postcode, postcode: { accept_partial_postcode: :accept_partial_postcode }
  end

  before { instance.valid? }
  subject { instance.errors.to_h }

  context "with invalid full postcodes" do
    ["F00BAR", "123ABC", "TE57 ING"].each do |postcode|
      context "checking '#{postcode}'" do
        let(:instance) { TestModel.new(postcode: postcode) }
        it { is_expected.to include postcode: "is invalid" }
      end
    end
  end

  context "with valid full postcodes" do
    ["M1 2WD", "TE57 1NG", ""].each do |postcode|
      context "checking '#{postcode}'" do
        let(:instance) { TestModel.new(postcode: postcode) }
        it { is_expected.not_to include :postcode }
      end
    end
  end

  context "with valid outward only postcodes" do
    %w[ST6 M1 TE57].each do |postcode|
      context "checking '#{postcode}'" do
        let(:instance) { TestModel.new(postcode: postcode, accept_partial_postcode: true) }
        it { is_expected.not_to include :postcode }
      end
    end
  end
end
