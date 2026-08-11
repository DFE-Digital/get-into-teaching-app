require "rails_helper"

RSpec.describe ProviderEvents::Steps::ReviewAnswers do
  include_context "with wizard step"

  let(:answers_by_step) do
    {
      ProviderEvents::Steps::Email => { email: "test@test.test" },
      ProviderEvents::Steps::EventName => { event_name: "Event Name" },
      ProviderEvents::Steps::EventDescription => { description: "Event Description" },
      ProviderEvents::Steps::OrganisationName => { organisation_name: "Organisation Name" },
      ProviderEvents::Steps::EventWebsite => { event_website: "https://www.example.com" },
      ProviderEvents::Steps::TargetAudience => { target_audience: "Target Audience" },
      ProviderEvents::Steps::EventDate => { event_date: "01/01/2999" },
      ProviderEvents::Steps::EventTimes => { start_time: "09:00", end_time: "17:30" },
      ProviderEvents::Steps::EventType => { event_type: "in_person" },
      ProviderEvents::Steps::OnlinePostcode => {},
      ProviderEvents::Steps::InPersonLocation => { location_option: "new" },
      ProviderEvents::Steps::NewVenue => { venue_name: "Venue Name", address_line_1: "Address Line 1", address_city: "Londontown", address_postcode: "WC1A 1AA" },
      ProviderEvents::Steps::RegistrationDetails => { registration_option: "website", registration_website: "https://www.example.com/register" },
    }
  end

  it_behaves_like "a with wizard step"

  describe "#seen?" do
    it { is_expected.not_to be_seen }
  end

  describe "#event_details_answers_by_step" do
    subject { instance.event_details_answers_by_step }

    before do
      allow_any_instance_of(described_class).to \
        receive(:answers_by_step).and_return answers_by_step
    end

    it {
      expect(subject).to eq(answers_by_step.slice(
                              ProviderEvents::Steps::Email,
                              ProviderEvents::Steps::EventName,
                              ProviderEvents::Steps::EventDescription,
                              ProviderEvents::Steps::OrganisationName,
                              ProviderEvents::Steps::EventWebsite,
                              ProviderEvents::Steps::TargetAudience,
                              ProviderEvents::Steps::EventDate,
                              ProviderEvents::Steps::EventTimes,
                            ))
    }
  end

  describe "#venue_details_answers_by_step" do
    subject { instance.venue_details_answers_by_step }

    before do
      allow_any_instance_of(described_class).to \
        receive(:answers_by_step).and_return answers_by_step
    end

    it {
      expect(subject).to eq(answers_by_step.slice(
                              ProviderEvents::Steps::EventType,
                              ProviderEvents::Steps::OnlinePostcode,
                              ProviderEvents::Steps::InPersonLocation,
                              ProviderEvents::Steps::NewVenue,
                            ))
    }
  end

  describe "#registration_details_answers_by_step" do
    subject { instance.registration_details_answers_by_step }

    before do
      allow_any_instance_of(described_class).to \
        receive(:answers_by_step).and_return answers_by_step
    end

    it {
      expect(subject).to eq(answers_by_step.slice(
                              ProviderEvents::Steps::RegistrationDetails,
                            ))
    }
  end
end
