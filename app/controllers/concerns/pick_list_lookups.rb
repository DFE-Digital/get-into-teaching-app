module PickListLookups
  def degree_status(id)
    @degree_statuses ||= GetIntoTeachingApiClient::PickListItemsApi.new.get_qualification_degree_status
    find_by_id(@degree_statuses, id)
  end

  def degree_country(id)
    @degree_countries ||= GetIntoTeachingApiClient::LookupItemsApi.new.get_degree_countries
    find_by_id(@degree_countries, id)
  end

  def citizenship(id)
    @citizenships ||= GetIntoTeachingApiClient::PickListItemsApi.new.get_candidate_citizenship
    find_by_id(@citizenships, id)
  end

  def situation(id)
    @situations ||= GetIntoTeachingApiClient::PickListItemsApi.new.get_candidate_situations
    find_by_id(@situations, id)
  end

  def visa_status(id)
    @visa_statuses ||= GetIntoTeachingApiClient::PickListItemsApi.new.get_candidate_visa_status
    find_by_id(@visa_statuses, id)
  end

  def location(id)
    @locations ||= GetIntoTeachingApiClient::PickListItemsApi.new.get_candidate_location
    find_by_id(@locations, id)
  end

  def find_by_id(list, id)
    list.find { |x| x.id == id } if list.present? && id.present?
  end
end
