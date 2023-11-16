require "feedback_exporter"
class FeedbacksController < ApplicationController
  RECENT_AMOUNT = 10
  RESTRICTED_ACTIONS = %w[index export].freeze

  before_action :check_feature_switch
  before_action :load_recent_feedback, only: %i[index export]
  before_action :restrict_access, if: :authenticate?

  def index
    @search = FeedbackSearch.new
  end

  def export
    @search = FeedbackSearch.new(feedback_search_params)

    if @search.valid?
      filename = "feedback-#{@search.range.join('--')}"
      exporter = FeedbackExporter.new(@search.results)

      respond_to do |format|
        format.csv { send_data exporter.to_csv, filename: "#{filename}.csv" }
      end
    else
      render :index, formats: %i[html]
    end
  end

  def restrict_access
    raise_forbidden if action_restricted? && !session[:user].feedback?
  end

protected

  def authenticate?
    Rails.env.production? ? action_restricted? : super
  end

private

  def check_feature_switch
    raise_not_found unless ActiveModel::Type::Boolean.new.cast(ENV["GET_AN_ADVISER_FEEDBACK"])
  end

  def action_restricted?
    RESTRICTED_ACTIONS.include?(action_name)
  end

  def load_recent_feedback
    @recent_feedback = UserFeedback.recent.limit(RECENT_AMOUNT)
  end

  def feedback_search_params
    params.require(:feedback_search).permit(
      :created_on_or_after,
      :created_on_or_before,
    )
  end
end
