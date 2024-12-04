class PageModification < ApplicationRecord
  validates :path, presence: true, uniqueness: true
  validates :content_hash, presence: true
end
