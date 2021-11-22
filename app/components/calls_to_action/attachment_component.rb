# frozen_string_literal: true

class CallsToAction::AttachmentComponent < ViewComponent::Base
  attr_reader :text, :file_path, :file_type, :file_size, :published_at, :updated_at

  def initialize(text:, file_path:, file_type: nil, file_size: nil, published_at: nil, updated_at: nil)
    super

    @text = text
    @file_path = file_path
    @file_type = file_type
    @file_size = file_size
    @published_at = published_at
    @updated_at = updated_at
  end

  def asset_path
    asset_pack_path(file_path)
  end

  def body
    file_type.present? && file_size.present? ? "#{text} (#{file_type} #{file_size})" : text
  end

  def icon_class
    "file-#{file_type.downcase}" if file_type.present?
  end
end
