require "rails_helper"

describe GetIntoTeachingApi::Types::Base do
  class Address < GetIntoTeachingApi::Types::Base
    self.type_cast_rules = {
      "postcode" => :normalize_postcode,
    }.freeze

  private

    def normalize_postcode(postcode)
      postcode.to_s.gsub(/\s+/, "").downcase
    end
  end

  class Person < GetIntoTeachingApi::Types::Base
    self.type_cast_rules = {
      "date_of_birth" => :date,
      "datetime" => :datetime,
      "id" => :integer,
      "address" => Address,
    }.freeze
  end

  describe "Type casting" do
    let(:dob) { "1990-01-01" }
    let(:datetime) { DateTime.now }
    let(:data) do
      {
        "id" => "123",
        "firstname" => "Joe",
        "date_of_birth" => dob,
        "datetime" => datetime.xmlschema,
        "address" => {
          "housenumber" => 23,
          "postcode" => "MA1 1AM",
        },
      }
    end

    let(:person) { Person.new data }

    subject { person }
    it { is_expected.to be_kind_of Person }
    it { is_expected.to have_attributes id: 123 }
    it { is_expected.to have_attributes firstname: "Joe" }
    it { is_expected.to have_attributes date_of_birth: Date.parse(dob) }
    it { is_expected.to have_attributes address: kind_of(Address) }
    it { expect(subject.datetime.to_s).to eql datetime.to_s }

    context "nested types" do
      subject { person.address }

      it { is_expected.to be_kind_of Address }
      it { is_expected.to have_attributes housenumber: 23 }
      it { is_expected.to have_attributes postcode: "ma11am" }
    end

    context "symbolized keys" do
      let(:data) { { firstname: "Joe", date_of_birth: dob } }
      it { is_expected.to have_attributes firstname: "Joe" }
      it { is_expected.to have_attributes date_of_birth: Date.parse(dob) }
    end
  end
end
