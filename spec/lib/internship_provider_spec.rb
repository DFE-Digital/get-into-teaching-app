require "spec_helper"
require "internship_provider"
require "csv"

describe InternshipProvider do
  let(:csv) do
    CSV.parse("school_name,region,school_website,contact_name,contact_email,subjects,areas,applications,full\n" \
                "School Name,Yorkshire and the Humber,https://example.test/,Test User,test.user@test.test,\"computing, design and technology, maths, physics\",\"Kirklees, Leeds and Bradford\",Open\n" \
                "School With No Contact Info,London,https://example2.test2/,,,\"art, biology, chemistry\",\"Westminster\",Closed,TRUE\n", headers: true)
  end

  context "when the data has contact details" do
    let(:data) do
      described_class.new(csv[0])
    end

    describe "#school_name" do
      subject { data.school_name }

      it { is_expected.to eql("School Name") }
    end

    describe "#region" do
      subject { data.region }

      it { is_expected.to eql("Yorkshire and the Humber") }
    end

    describe "#website" do
      subject { data.school_website }

      it { is_expected.to eql("https://example.test/") }
    end

    describe "#contact_name" do
      subject { data.contact_name }

      it { is_expected.to eql("Test User") }
    end

    describe "#contact_email" do
      subject { data.contact_email }

      it { is_expected.to eql("test.user@test.test") }
    end

    describe "#subjects" do
      subject { data.subjects }

      it { is_expected.to eql("computing, design and technology, maths, physics") }
    end

    describe "#areas" do
      subject { data.areas }

      it { is_expected.to eql("Kirklees, Leeds and Bradford") }
    end

    describe "#applications" do
      subject { data.applications }

      it { is_expected.to eql("Open") }
    end

    describe "#full" do
      subject { data.full }

      it { is_expected.to be_nil }
    end

    describe "#to_h" do
      subject { data.to_h }

      it {
        is_expected.to eql(
          {
            "header" => "School Name",
            "link" => "https://example.test/",
            "subjects" => "computing, design and technology, maths, physics",
            "areas" => "Kirklees, Leeds and Bradford",
            "applications" => "Open",
            "name" => "Test User",
            "email" => "test.user@test.test",
          },
        )
      }
    end

    describe "#to_str" do
      subject { data.to_str }

      it { is_expected.to eql("School Name|Kirklees, Leeds and Bradford|Yorkshire and the Humber|https://example.test/|test.user@test.test") }
    end
  end

  context "when the data does not have contact details" do
    let(:data) do
      described_class.new(csv[1])
    end

    describe "#school_name" do
      subject { data.school_name }

      it { is_expected.to eql("School With No Contact Info") }
    end

    describe "#region" do
      subject { data.region }

      it { is_expected.to eql("London") }
    end

    describe "#website" do
      subject { data.school_website }

      it { is_expected.to eql("https://example2.test2/") }
    end

    describe "#contact_name" do
      subject { data.contact_name }

      it { is_expected.to be_nil }
    end

    describe "#contact_email" do
      subject { data.contact_email }

      it { is_expected.to be_nil }
    end

    describe "#subjects" do
      subject { data.subjects }

      it { is_expected.to eql("art, biology, chemistry") }
    end

    describe "#areas" do
      subject { data.areas }

      it { is_expected.to eql("Westminster") }
    end

    describe "#applications" do
      subject { data.applications }

      it { is_expected.to eql("Closed") }
    end

    describe "#full" do
      subject { data.full }

      it { is_expected.to be true }
    end

    describe "#to_h" do
      subject { data.to_h }

      it {
        is_expected.to eql(
          {
            "header" => "School With No Contact Info",
            "link" => "https://example2.test2/",
            "status" => "Course full",
            "subjects" => "art, biology, chemistry",
          },
        )
      }
    end

    describe "#to_str" do
      subject { data.to_str }

      it { is_expected.to eql("School With No Contact Info|Westminster|London|https://example2.test2/|") }
    end
  end
end
