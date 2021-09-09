shared_examples "a controller with a #resend_verification action" do
  describe "#resend_verification" do
    it "redirects to the authentication_path with verification_resent: true" do
      perform_request
      expect(response).to redirect_to controller.send(:authenticate_path, verification_resent: true)
    end

    context "when the API returns 429 too many requests" do
      subject! do
        allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
          receive(:create_candidate_access_token).and_raise(too_many_requests_error)
        perform_request
        response.body
      end

      let(:too_many_requests_error) { GetIntoTeachingApiClient::ApiError.new(code: 429) }

      it { is_expected.to match(/Error 429/) }
      it { is_expected.to match(/Too many requests/) }
    end

    context "when the API returns 400 bad request" do
      subject! do
        allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
          receive(:create_candidate_access_token).and_raise(bad_request_error)
        perform_request
      end

      let(:bad_request_error) { GetIntoTeachingApiClient::ApiError.new(code: 400) }

      it { is_expected.to redirect_to(controller.send(:step_path, controller.wizard_class.steps.first.key)) }
    end
  end
end
