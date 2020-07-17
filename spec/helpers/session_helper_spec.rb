require "rails_helper"

describe SessionHelper, type: :helper do
  describe "#event_session" do
    it "defaults to an empty hash" do
      expect(event_session).to eq({})
    end

    it "returns the session event data associated with the event_id param" do
      params[:event_id] = "123"
      event_session_data = { email: "email@address.com" }
      session[:events] = { "123" => event_session_data }
      expect(event_session).to eq(event_session_data)
    end
  end

  describe "#mailing_list_session" do
    it "defaults to an empty hash" do
      expect(mailing_list_session).to eq({})
    end

    it "returns the session mailing list data" do
      mailing_list_session_data = { email: "email@address.com" }
      session[:mailinglist] = mailing_list_session_data
      expect(mailing_list_session).to eq(mailing_list_session_data)
    end
  end
end
