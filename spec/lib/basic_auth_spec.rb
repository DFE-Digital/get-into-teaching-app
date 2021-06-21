require "rails_helper"
require "basic_auth"

RSpec.describe BasicAuth do
  let(:http_auth) { "" }
  let(:instance) { described_class }

  before do
    allow(Rails.application.config.x).to receive(:http_auth) { http_auth }
    described_class.class_variable_set(:@@credentials, nil)
  end

  describe ".env_requires_auth?" do
    before { allow(Rails).to receive(:env) { env.inquiry } }
    subject { instance.env_requires_auth? }

    env_auth = {
      "production" => false,
      "rolling" => true,
      "preprod" => true,
      "userresearch" => true,
      "test" => false,
      "development" => false,
    }.freeze

    env_auth.each do |k, auth|
      context "when #{k}" do
        let(:env) { k }

        it { is_expected.to eq(auth) }
      end
    end
  end

  describe ".credentials" do
    subject { instance.credentials }

    it { is_expected.to eq([]) }

    context "when http_auth is present" do
      let(:http_auth) { "username1|password1|role1,username2|password2," }

      it do
        is_expected.to contain_exactly(
          { username: "username1", password: "password1", role: "role1" },
          { username: "username2", password: "password2", role: nil },
        )
      end
    end
  end

  describe ".authenticate" do
    let(:username) { "" }
    let(:password) { "" }

    subject { instance.authenticate(username, password) }

    it { is_expected.to be_falsy }

    context "when http_auth has an empty credential" do
      let(:http_auth) { "=" }

      it { is_expected.to be_falsy }
    end

    context "when http_auth is present" do
      let(:http_auth) { "username1|password1,username2|password2,username2|password3" }

      context "when the username/password are incorrect" do
        let(:username) { "username1" }
        let(:password) { "password2" }

        it { is_expected.to be_falsy }
      end

      context "when the username/password are correct" do
        let(:username) { "username1" }
        let(:password) { "password1" }

        it do
          is_expected.to be_truthy
          is_expected.to be_an_instance_of(User)
          expect(subject.username).to eq("username1")
          expect(subject.publisher?).to be false
          expect(subject.author?).to be false
        end

        context "when user role is publisher" do
          let(:http_auth) { "username1|password1|publisher" }

          it "responds to `publisher?`" do
            expect(subject.publisher?).to be true
          end
        end

        context "when user role is author" do
          let(:http_auth) { "username1|password1|author" }

          it "responds to `author?`" do
            expect(subject.author?).to be true
          end
        end
      end

      context "when the username/password are correct (duplicate username, different password)" do
        let(:username) { "username2" }
        let(:password) { "password3" }

        it { is_expected.to be_truthy }
      end
    end
  end
end
