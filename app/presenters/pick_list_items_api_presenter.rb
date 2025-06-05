class PickListItemsApiPresenter
  # A presenter to filter and sort picklists down to just the options we want to display
  # .delegate_and_filter takes the method from the PickListItemsApi and a list of ids to filter down to
  # Note that the array of ids given to .delegate_and_filter, is also used to sort them,
  # this is useful for changing the order of items in the front end

  attr_reader :picklist_items_api

  def initialize(picklist_items_api = GetIntoTeachingApiClient::PickListItemsApi.new)
    @api = picklist_items_api
  end

  def self.delegate_and_filter(method_name, filter_ids)
    define_method(method_name) do
      items = @api.public_send(method_name).select do |option|
        filter_ids.include?(option.id)
      end

      items.sort_by { |item| filter_ids.index(item.id) }
    end
  end

  delegate_and_filter(:get_candidate_journey_stages, [222_750_000, 222_750_003])
  delegate_and_filter(:get_qualification_degree_status, [222_750_000, 222_750_006, 222_750_004])
end
