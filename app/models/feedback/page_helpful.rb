module Feedback
  class PageHelpful
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :url, :string
    attribute :answer, :string

    validates :url, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
    validates :answer, presence: true, inclusion: { in: %w[yes no] }
  end
end
