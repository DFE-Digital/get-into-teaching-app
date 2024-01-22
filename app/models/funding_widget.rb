class FundingWidget
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :subject, :string
  validates :subject, presence: true

  def content_errors
    errors.map do |e|
      Pages::ContentError.new(e.message.to_s, "#funding_widget_#{e.attribute}")
    end
  end
end
