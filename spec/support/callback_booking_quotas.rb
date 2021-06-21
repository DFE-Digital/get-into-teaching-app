RSpec.shared_examples "exposes callback booking quotas" do
  before do
    allow_any_instance_of(GetIntoTeachingApiClient::CallbackBookingQuotasApi).to \
      receive(:get_callback_booking_quotas) { quotas }
  end

  let(:utc_now) { DateTime.now.utc }
  let(:quota_in_30_minutes) do
    GetIntoTeachingApiClient::CallbackBookingQuota.new(
      startAt: utc_now + 30.minutes,
      endAt: utc_now + 60.minutes,
    )
  end
  let(:quota_in_90_minutes) do
    GetIntoTeachingApiClient::CallbackBookingQuota.new(
      startAt: utc_now + 90.minutes,
      endAt: utc_now + 120.minutes,
    )
  end
  let(:quotas) { [quota_in_30_minutes, quota_in_90_minutes] }

  describe "#callback_booking_quotas" do
    let(:time_zone) { "UTC" }

    subject { described_class.callback_booking_quotas }

    around do |example|
      Time.use_zone(time_zone) { example.run }
    end

    it { is_expected.to contain_exactly(quota_in_90_minutes) }
  end
end
