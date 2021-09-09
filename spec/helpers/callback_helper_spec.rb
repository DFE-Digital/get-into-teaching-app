require "rails_helper"

RSpec.describe CallbackHelper, type: :helper do
  around do |example|
    travel_to(utc_today) do
      Time.use_zone(time_zone) { example.run }
    end
  end

  let(:time_zone) { "UTC" }
  let(:utc_today) { Time.utc(2020, 4, 6, 10, 30) }
  let(:utc_tomorrow) { Time.utc(2020, 4, 7, 10) }
  let(:quota_today) do
    GetIntoTeachingApiClient::CallbackBookingQuota.new(
      startAt: utc_today,
      endAt: utc_today + 30.minutes,
    )
  end
  let(:quota_tomorrow) do
    GetIntoTeachingApiClient::CallbackBookingQuota.new(
      startAt: utc_tomorrow,
      endAt: utc_tomorrow + 30.minutes,
    )
  end
  let(:quotas) { [quota_today, quota_tomorrow] }

  describe "#callback_options" do
    subject { callback_options(quotas) }

    it {
      is_expected.to eq({
        "Monday 6 April" => [["10:30 am - 11:00 am", utc_today]],
        "Tuesday 7 April" => [["10:00 am - 10:30 am", utc_tomorrow]],
      })
    }

    context "when given a time zone of GMT+2" do
      let(:time_zone) { "Madrid" }

      it {
        is_expected.to eq({
          "Monday 6 April" => [["12:30 pm - 1:00 pm", utc_today]],
          "Tuesday 7 April" => [["12:00 pm - 12:30 pm", utc_tomorrow]],
        })
      }
    end
  end

  describe "#quotas_by_day" do
    subject { quotas_by_day(quotas) }

    it {
      is_expected.to eq({
        "Monday 6 April" => [quota_today],
        "Tuesday 7 April" => [quota_tomorrow],
      })
    }

    context "when given a time zone of GMT-11 (resulting in 'today' being the 5th)" do
      let(:time_zone) { "American Samoa" }

      it {
        is_expected.to eq({
          "Sunday 5 April" => [quota_today],
          "Monday 6 April" => [quota_tomorrow],
        })
      }
    end
  end
end
