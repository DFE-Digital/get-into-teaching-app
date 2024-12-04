require "page_modification_tracker"

class TrackPageModificationsJob < ApplicationJob
  queue_as :default

  def perform(host:)
    PageModificationTracker.new(host: host).track_page_modifications
  end
end
