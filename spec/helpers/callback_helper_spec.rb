require "rails_helper"

RSpec.describe CallbackHelper, type: :helper do
  around do |example|
    Time.use_zone(time_zone) { example.run }
  end

  let(:quota_today) do
    GetIntoTeachingApiClient::CallbackBookingQuota.new(
      start_at: crm_today,
      end_at: crm_today + 30.minutes,
    )
  end
  let(:quota_tomorrow) do
    GetIntoTeachingApiClient::CallbackBookingQuota.new(
      start_at: crm_tomorrow,
      end_at: crm_tomorrow + 30.minutes,
    )
  end

  let(:crm_tomorrow) { crm_today + 23.hours }

  let(:quotas) { [quota_today, quota_tomorrow] }
  let(:quotas_by_day_values) { quotas_by_day(quotas).values.flatten.map { |v| [v.day, v.start_at, v.start_at_local_time] } }

  # NB: the times provided by the CRM are local and the CRM timezone (UTC) should be ignored
  let(:crm_2026_01_06_1030_not_utc) { Time.utc(2026, 1, 6, 10, 30) }
  let(:crm_2026_07_01_1030_not_utc) { Time.utc(2026, 7, 1, 10, 30) }

  context "when in London (GMT)" do
    let(:time_zone) { "Europe/London" }

    context "when outside of daylight saving time" do
      let(:crm_today) { crm_2026_01_06_1030_not_utc }

      describe "#callback_options" do
        subject { callback_options(quotas) }

        it {
          is_expected.to eq({
            "Tuesday 6 January" => [["10:30am to 11:00am", crm_today]],
            "Wednesday 7 January" => [["9:30am to 10:00am", crm_tomorrow]],

          })
        }
      end

      describe "#quotas_by_day" do
        subject { quotas_by_day_values }

        it {
          is_expected.to contain_exactly(["Tuesday 6 January", crm_today, "10:30am"], ["Wednesday 7 January", crm_tomorrow, "9:30am"])
        }
      end
    end

    context "when inside of daylight saving time" do
      # NB: the times provided by the CRM are local and the CRM timezone (UTC) should be ignored
      let(:crm_today) { crm_2026_07_01_1030_not_utc }

      describe "#callback_options" do
        subject { callback_options(quotas) }

        it {
          is_expected.to eq({
            "Wednesday 1 July" => [["10:30am to 11:00am", crm_today]],
            "Thursday 2 July" => [["9:30am to 10:00am", crm_tomorrow]],
          })
        }
      end

      describe "#quotas_by_day" do
        subject { quotas_by_day_values }

        it {
          is_expected.to contain_exactly(["Wednesday 1 July", crm_today, "10:30am"], ["Thursday 2 July", crm_tomorrow, "9:30am"])
        }
      end
    end
  end

  context "when in American Samoa (GMT-11)" do
    let(:time_zone) { "American Samoa" }

    context "when outside of daylight saving time" do
      # NB: the times provided by the CRM are local and the CRM timezone (UTC) should be ignored
      let(:crm_today) { crm_2026_01_06_1030_not_utc }

      describe "#callback_options" do
        subject { callback_options(quotas) }

        it {
          is_expected.to eq({

            "Monday 5 January" => [["11:30pm to 12:00am", crm_today]],
            "Tuesday 6 January" => [["10:30pm to 11:00pm", crm_tomorrow]],

          })
        }
      end

      describe "#quotas_by_day" do
        subject { quotas_by_day_values }

        it {
          is_expected.to contain_exactly(["Monday 5 January", crm_today, "11:30pm"], ["Tuesday 6 January", crm_tomorrow, "10:30pm"])
        }
      end
    end

    context "when inside of daylight saving time" do
      # NB: the times provided by the CRM are local and the CRM timezone (UTC) should be ignored
      let(:crm_today) { crm_2026_07_01_1030_not_utc }

      describe "#callback_options" do
        subject { callback_options(quotas) }

        it {
          is_expected.to eq({
            "Tuesday 30 June" => [["10:30pm to 11:00pm", crm_today]],
            "Wednesday 1 July" => [["9:30pm to 10:00pm", crm_tomorrow]],
          })
        }
      end

      describe "#quotas_by_day" do
        subject { quotas_by_day_values }

        it {
          is_expected.to contain_exactly(["Tuesday 30 June", crm_today, "10:30pm"], ["Wednesday 1 July", crm_tomorrow, "9:30pm"])
        }
      end
    end
  end

  describe "#callback_available?" do
    let(:time_zone) { "UTC" }
    let(:crm_today) { crm_2026_01_06_1030_not_utc }

    around do |example|
      travel_to(crm_today) { example.run }
    end

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::CallbackBookingQuotasApi).to \
        receive(:get_callback_booking_quotas) { quotas }
    end

    subject { helper }

    it { is_expected.to be_callback_available }

    context "when there are no quotas" do
      let(:quotas) { [] }

      it { is_expected.not_to be_callback_available }
    end
  end
end
