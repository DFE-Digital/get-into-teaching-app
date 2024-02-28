class PreviewController < ApplicationController
  include ViewComponent::PreviewActions

  before_action :setup_breadcrumbs, if: -> { request.path.downcase.ends_with?("/view_components/header/breadcrumb_component/default") }

  def setup_breadcrumbs
    breadcrumb "Page 1", "/page/1"
    breadcrumb "Page 2", "/page/2"
    breadcrumb "Page 3", "/page/3"
    breadcrumb "Current Page", request.path
  end
end
