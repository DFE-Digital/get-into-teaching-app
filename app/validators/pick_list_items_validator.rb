class PickListItemsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    items = GetIntoTeachingApiClient::PickListItemsApi.new.send(options[:method])

    unless items.map { |item| item.id.to_s }.include?(value.to_s)
      record.errors.add(attribute, :invalid_type)
    end
  end
end
