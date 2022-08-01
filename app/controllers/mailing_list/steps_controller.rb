module MailingList
  class StepsController < ApplicationController
    include CircuitBreaker

    include GITWizard::Controller
    self.wizard_class = MailingList::Wizard

    before_action :noindex, unless: -> { request.path.include?("/name") }
    before_action :set_step_page_title, only: %i[show update]
    before_action :set_completed_page_title, only: [:completed]
    before_action :load_campaign_frontmatter, only: %i[show update completed], if: -> { campaign_id.present? }

    layout :resolve_layout

    def not_available
      render "not_available"
    end

  protected

    def not_available_path
      mailinglist_not_available_path
    end

  private

    def step_path(step = params[:id], urlparams = {})
      if campaign_id.present?
        mailing_list_campaign_path step, campaign_id, urlparams
      else
        mailing_list_step_path step, urlparams
      end
    end
    helper_method :step_path

    def wizard_store
      ::GITWizard::Store.new app_store, crm_store
    end

    def app_store
      session[:mailinglist] ||= {}
    end

    def crm_store
      session[:mailinglist_crm] ||= {}
    end

    def campaign_id
      params[:campaign_id]
    end

    def resolve_layout
      is_first_page = @current_step.instance_of? MailingList::Steps::Name
      return "registration_with_campaign" if is_first_page && campaign_id.present?
      return "registration_with_side_images" if is_first_page

      "registration"
    end

    def load_campaign_frontmatter
      campaigns = YAML.load_file(Rails.root.join("config/campaigns.yml"))
      raise_not_found unless campaigns.key?(campaign_id)
      @front_matter = campaigns[campaign_id]
    end

    def set_step_page_title
      @page_title = "Get personalised guidance to your inbox"
      unless @current_step.nil?
        @page_title += ", #{@current_step.title.downcase} step"
      end
    end

    def set_completed_page_title
      @page_title = "You've signed up"
    end
  end
end
