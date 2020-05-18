require "rails_helper"

describe GetIntoTeachingApi::Types::Base do

  class Address < GetIntoTeachingApi::Types::Base
    self.type_cast_rules = {
      "postcode" => :normalize_postcode
    }.freeze

  private
    def normalize_postcode(postcode)
      postcode.to_s.gsub(/\s+/, '').downcase
    end
  end

  class Person < GetIntoTeachingApi::Types::Base
    self.type_cast_rules = {
      "date_of_birth" => :date,
      "address" => Address
    }.freeze
  end

  describe "Type casting" do
    let(:data) do
      {
        "firstname" => "Joe",
        "date_of_birth" => "1990-01-01",
        "address" => {
          "housenumber" => 23,
          "postcode" => "MA1 1AM"
        }
      }
    end

    let(:person) { Person.new data }

    subject { person }

    it { is_expected.to be_kind_of Person }
    it { is_expected.to have_attributes firstname: "Joe" }
    it { is_expected.to have_attributes date_of_birth: Date.parse("1990-01-01") }
    it { is_expected.to have_attributes address: kind_of(Address) }

    context "nested types" do
      subject { person.address }

      it { is_expected.to be_kind_of Address }
      it { is_expected.to have_attributes housenumber: 23 }
      it { is_expected.to have_attributes postcode: "ma11am" }
    end
  end

end
