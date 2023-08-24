require "rails_helper"

RSpec.describe "Feedback" do
  let(:feedback_flag) { "1" }

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("GET_AN_ADVISER_FEEDBACK").and_return(feedback_flag)
  end

  subject { response }

  describe "#new" do
    before { get new_teacher_training_adviser_feedback_path }

    it { is_expected.to have_http_status(:success) }
    it { expect(response.body).to include("Give feedback on this service") }

    context "when disabled" do
      let(:feedback_flag) { "0" }

      it { is_expected.to have_http_status(:not_found) }
    end
  end

  describe "#create" do
    let(:params) do
      {
        teacher_training_adviser_feedback: attributes_for(:feedback),
      }
    end

    it "creates a Feedback and redirects to a thank you page" do
      allow(ActiveSupport::Notifications).to receive(:instrument).and_call_original
      expect(ActiveSupport::Notifications).to receive(:instrument)
        .with("app.tta_feedback", instance_of(TeacherTrainingAdviser::Feedback))

      expect { post teacher_training_adviser_feedbacks_path, params: params }.to \
        change(TeacherTrainingAdviser::Feedback, :count).by(1)

      expect(response).to redirect_to(thank_you_teacher_training_adviser_feedbacks_path)
      follow_redirect!
      expect(response.body).to include("Thank you for your feedback.")
    end

    context "when there are errors" do
      let(:params) { { teacher_training_adviser_feedback: { rating: nil } } }

      before { post teacher_training_adviser_feedbacks_path, params: params }

      it { is_expected.to have_http_status(:success) }
      it { expect(response.body).to include("Give feedback on this service") }
      it { expect(response.body).to include("Select an option for how did you feel about the service") }
    end

    context "when disabled" do
      let(:feedback_flag) { "0" }

      before { post(teacher_training_adviser_feedbacks_path, params: params) }

      it { is_expected.to have_http_status(:not_found) }
    end
  end

  describe "#index" do
    context "when there are feedback submissions" do
      before do
        create(:feedback, rating: :very_satisfied, successful_visit: true, improvements: "None")
        create(:feedback, rating: :very_dissatisfied, successful_visit: false, unsuccessful_visit_explanation: "Awful")

        get teacher_training_adviser_feedbacks_path
      end

      it { is_expected.to have_http_status(:success) }
      it { expect(response.body).to include("Service feedback") }
      it { expect(response.body).to include("2 most recent feedback submissions") }

      it "contains the recent feedback details" do
        expect(response.body).to match(/<th.*>Date<\/th>/)
        expect(response.body).to match(/<th.*>Rating<\/th>/)
        expect(response.body).to match(/<th.*>Successful visit<\/th>/)
        expect(response.body).to match(/<th.*>Visit explanation<\/th>/)
        expect(response.body).to match(/<th.*>Topic<\/th>/)

        expect(response.body).to match(/<td.*>Very satisfied<\/td>/)
        expect(response.body).to match(/<td.*>Yes<\/td>/)

        expect(response.body).to match(/<td.*>Very dissatisfied<\/td>/)
        expect(response.body).to match(/<td.*>No<\/td>/)
        expect(response.body).to match(/<td.*>Awful<\/td>/)
      end
    end

    context "when there are no feedback submissions" do
      before { get teacher_training_adviser_feedbacks_path }

      it { expect(response.body).to include("There are no feedback submissions yet.") }
    end

    context "when disabled" do
      let(:feedback_flag) { "0" }

      before { get teacher_training_adviser_feedbacks_path }

      it { is_expected.to have_http_status(:not_found) }
    end
  end

  describe "#export" do
    subject { response.body }

    let(:params) do
      {
        teacher_training_adviser_feedback_search: {
          created_on_or_after: Time.zone.local(2020, 3, 1),
          created_on_or_before: Time.zone.local(2020, 3, 1),
        },
      }
    end
    let!(:feedback) do
      [
        create(:feedback, rating: :very_satisfied)
          .tap { |f| f.update(created_at: Time.zone.local(2020, 3, 1, 10)) },
        create(:feedback, rating: :very_dissatisfied)
          .tap { |f| f.update(created_at: Time.zone.local(2020, 3, 1, 11)) },
        create(:feedback, rating: :satisfied)
          .tap { |f| f.update(created_at: Time.zone.local(2020, 3, 1, 12)) },
      ]
    end

    before { post export_teacher_training_adviser_feedbacks_path(format: :csv), params: params }

    it { expect(response).to have_http_status(:success) }
    it { expect(response.content_type).to eq("text/csv") }

    it do
      expect(subject).to eq(
        <<~CSV,
          id,rating,successful_visit,unsuccessful_visit_explanation,created_at,topic
          #{feedback[2].id},satisfied,true,"",#{feedback[2].created_at},""
          #{feedback[1].id},very_dissatisfied,true,"",#{feedback[1].created_at},""
          #{feedback[0].id},very_satisfied,true,"",#{feedback[0].created_at},""
        CSV
      )
    end

    context "when there are errors" do
      let(:params) do
        {
          teacher_training_adviser_feedback_search: {
            created_on_or_after: 1.day.from_now,
            created_on_or_before: 1.day.ago,
          },
        }
      end

      it { expect(response).to have_http_status(:success) }
      it { expect(response.content_type).to eq("text/html; charset=utf-8") }
      it { expect(response.body).to include("Service feedback") }
      it { expect(response.body).to include("Created on or after must be earlier than created on or before") }
    end

    context "when there is no matching feedback to export" do
      let(:feedback) { [] }

      it { expect(response).to have_http_status(:success) }
      it { expect(response.content_type).to eq("text/csv") }

      it do
        expect(subject).to eq(
          <<~CSV,
            id,rating,successful_visit,unsuccessful_visit_explanation,created_at,topic
          CSV
        )
      end
    end

    context "when disabled" do
      let(:feedback_flag) { "0" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe "basic auth" do
    before do
      allow_basic_auth_users([
        { username: "feedback", password: "password1", role: "feedback" },
        { username: "user", password: "password2", role: "user" },
      ])
    end

    context "when in production and basic auth is disabled" do
      before do
        allow(Rails).to receive(:env) { "production".inquiry }
        allow(Rails.application.config.x).to receive(:basic_auth).and_return("0")
      end

      describe "#new" do
        before { get new_teacher_training_adviser_feedback_path }

        it { is_expected.to have_http_status(:success) }
      end

      describe "#create" do
        let(:params) { { teacher_training_adviser_feedback: { rating: nil } } }

        before { post teacher_training_adviser_feedbacks_path, params: params }

        it { is_expected.to have_http_status(:success) }
      end

      describe "#thank_you" do
        before { get thank_you_teacher_training_adviser_feedbacks_path }

        it { is_expected.to have_http_status(:success) }
      end

      describe "#index" do
        before { get teacher_training_adviser_feedbacks_path, params: {}, headers: headers }

        it { is_expected.to have_http_status(:unauthorized) }

        context "when feedback user" do
          let(:headers) { basic_auth_headers("feedback", "password1") }

          it { is_expected.to have_http_status(:success) }
        end

        context "when not feedback user" do
          let(:headers) { basic_auth_headers("user", "password2") }

          it { is_expected.to have_http_status(:forbidden) }
        end
      end

      describe "#export" do
        let(:params) do
          {
            teacher_training_adviser_feedback_search: {
              created_on_or_after: Time.zone.local(2020, 3, 1),
              created_on_or_before: Time.zone.local(2020, 3, 1),
            },
          }
        end

        before { post export_teacher_training_adviser_feedbacks_path(format: :csv), params: params, headers: headers }

        it { is_expected.to have_http_status(:unauthorized) }

        context "when feedback user" do
          let(:headers) { basic_auth_headers("feedback", "password1") }

          it { is_expected.to have_http_status(:success) }
        end

        context "when not feedback user" do
          let(:headers) { basic_auth_headers("user", "password2") }

          it { is_expected.to have_http_status(:forbidden) }
        end
      end
    end

    context "when in a production-like environment (rolling/preprod) and basic auth is enabled" do
      before do
        allow(Rails).to receive(:env) { "rolling".inquiry }
        allow(Rails.application.config.x).to receive(:basic_auth).and_return("1")
      end

      describe "#new" do
        before { get new_teacher_training_adviser_feedback_path, params: {}, headers: headers }

        it { is_expected.to have_http_status(:unauthorized) }

        context "when not feedback user" do
          let(:headers) { basic_auth_headers("user", "password2") }

          it { is_expected.to have_http_status(:success) }
        end
      end

      describe "#create" do
        let(:params) { { teacher_training_adviser_feedback: { rating: nil } } }

        before { post teacher_training_adviser_feedbacks_path, params: params, headers: headers }

        it { is_expected.to have_http_status(:unauthorized) }

        context "when not feedback user" do
          let(:headers) { basic_auth_headers("user", "password2") }

          it { is_expected.to have_http_status(:success) }
        end
      end

      describe "#thank_you" do
        before { get thank_you_teacher_training_adviser_feedbacks_path, params: {}, headers: headers }

        it { is_expected.to have_http_status(:unauthorized) }

        context "when not feedback user" do
          let(:headers) { basic_auth_headers("user", "password2") }

          it { is_expected.to have_http_status(:success) }
        end
      end

      describe "#index" do
        before { get teacher_training_adviser_feedbacks_path, params: {}, headers: headers }

        it { is_expected.to have_http_status(:unauthorized) }

        context "when not feedback user" do
          let(:headers) { basic_auth_headers("user", "password2") }

          it { is_expected.to have_http_status(:forbidden) }
        end

        context "when feedback user" do
          let(:headers) { basic_auth_headers("feedback", "password1") }

          it { is_expected.to have_http_status(:success) }
        end
      end

      describe "#export" do
        let(:params) do
          {
            teacher_training_adviser_feedback_search: {
              created_on_or_after: Time.zone.local(2020, 3, 1),
              created_on_or_before: Time.zone.local(2020, 3, 1),
            },
          }
        end

        before { post export_teacher_training_adviser_feedbacks_path(format: :csv), params: params, headers: headers }

        it { is_expected.to have_http_status(:unauthorized) }

        context "when not feedback user" do
          let(:headers) { basic_auth_headers("user", "password2") }

          it { is_expected.to have_http_status(:forbidden) }
        end

        context "when feedback user" do
          let(:headers) { basic_auth_headers("feedback", "password1") }

          it { is_expected.to have_http_status(:success) }
        end
      end
    end
  end
end
