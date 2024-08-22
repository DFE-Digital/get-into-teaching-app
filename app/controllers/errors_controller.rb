class ErrorsController < ApplicationController
  layout "application"
  before_action :set_breadcrumbs

  def not_found
    respond_to do |format|
      format.html { render status: :not_found }
      format.json { render json: { error: "Resource not found" }, status: :not_found }
      format.all { render status: :not_found, body: nil }
    end
  end

  def forbidden
    respond_to do |format|
      format.html { render status: :forbidden }
      format.json { render json: { error: "Forbidden" }, status: :forbidden }
      format.all { render status: :forbidden, body: nil }
    end
  end

  def internal_server_error
    respond_to do |format|
      format.html { render status: :internal_server_error }
      format.json { render json: { error: "Internal server error" }, status: :internal_server_error }
      format.all { render status: :internal_server_error, body: nil }
    end
  end

  def unprocessable_entity
    respond_to do |format|
      format.html { render status: :unprocessable_entity }
      format.json { render json: { error: "Unprocessable entity" }, status: :unprocessable_entity }
      format.all { render status: :unprocessable_entity, body: nil }
    end
  end

private

  def set_breadcrumbs
    breadcrumb params[:action].humanize, request.path
  end
end
