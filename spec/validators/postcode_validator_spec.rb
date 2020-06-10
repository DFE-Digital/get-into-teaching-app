require "rails_helper"

describe PostcodeValidator do
  class TestModel
    include ActiveModel::Model
    attr_accessor :postcode
    validates :postcode, postcode: true
  end

  before { instance.valid? }
  subject { instance.errors.to_h }

  ["MA1 1AM", "F00BAR", "M1", "123ABC"].each do |postcode|
    context "checking '#{postcode}'" do
      let(:instance) { TestModel.new(postcode: postcode) }
      it { is_expected.to include postcode: "is invalid" }
    end
  end

  ["M1 2WD", "TE57 1NG", ""].each do |postcode|
    context "checking '#{postcode}'" do
      let(:instance) { TestModel.new(postcode: postcode) }
      it { is_expected.not_to include :postcode }
    end
  end
end
