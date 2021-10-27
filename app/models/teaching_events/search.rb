module TeachingEvents
  class Search
    include ActiveModel::Model

    attr_accessor :postcode, :setting, :type
  end
end
