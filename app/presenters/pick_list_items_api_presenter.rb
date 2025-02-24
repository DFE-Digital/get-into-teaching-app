class PickListItemsApiPresenter
  # A presenter to filter picklists down to just the options we want to display
  # .delegate_and_filter takes the method from the PickListItemsApi and a list of ids to filter down to

  attr_reader :picklist_items_api

  def initialize(picklist_items_api = GetIntoTeachingApiClient::PickListItemsApi.new)
    @api = picklist_items_api
  end

  def self.delegate_and_filter(method_name, filter_ids)
    define_method(method_name) do
      @api.public_send(method_name).select do |option|
        filter_ids.include?(option.id)
      end
    end
  end

  delegate_and_filter(:get_candidate_journey_stages, [222_750_000, 222_750_003])
end
