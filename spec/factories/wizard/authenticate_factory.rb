FactoryBot.define do
  factory :authenticate, class: "Wizard::Steps::Authenticate" do
    timed_one_time_password { "012345" }
  end
end
