class FundingWidget
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :subject, :string
  validates :subject, presence: true
end
