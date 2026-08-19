module ProviderEvents
  class Wizard < ::GITWizard::Base
    DEFAULT_ERROR_MESSAGE = "Choose an option from the list".freeze
    PENDING_REVIEW_STATUS_ID = 222_750_003
    ATTRIBUTES_TO_LEAVE = %w[email reference_number].freeze

    self.steps = [
      Steps::Email,
      Steps::EventName,
      Steps::EventDescription,
      Steps::OrganisationName,
      Steps::EventWebsite,
      Steps::TargetAudience,
      Steps::EventDate,
      Steps::EventTimes,
      Steps::EventType,
      Steps::OnlinePostcode,
      Steps::InPersonLocation,
      Steps::NewVenue,
      Steps::RegistrationDetails,
      Steps::ReviewAnswers,
    ]

    def complete!
      super.tap do |result|
        break unless result

        event = to_api_event(construct_export)

        response = GetIntoTeachingApiClient::TeachingEventsApi.new.upsert_teaching_event(event)
        @store[:reference_number] = response.reference_number

        @store.prune!(leave: ATTRIBUTES_TO_LEAVE)
      end
    end

  private

    def construct_export
      attributes = GetIntoTeachingApiClient::TeachingEvent.attribute_map.keys

      export_data.slice(*attributes.map(&:to_s))
    end

    def export_data
      super.tap do |data|
        find("event_type").tap do |event_type|
          data["type_id"] = event_type.api_id
          data["is_online"] = event_type.online?
          data["is_in_person"] = event_type.in_person?
          data["is_virtual"] = event_type.online?

          data["building"] ||= {}
          if event_type.online?
            data["building"]["venue"] = data["organisation_name"]
            data["building"]["address_postcode"] = data["online_postcode"]
          elsif event_type.in_person?
            find("in_person_location").tap do |in_person_location|
              if in_person_location.existing?
                data["building"]["id"] = data["building_id"]
              elsif in_person_location.new?
                find("new_venue").tap do |_new_venue|
                  data["building"]["venue"] = data["venue_name"]
                  data["building"]["address_line_1"] = data["address_line_1"]
                  data["building"]["address_line_2"] = data["address_line_2"]
                  data["building"]["address_line_3"] = data["address_line_3"]
                  data["building"]["address_city"] = data["address_city"]
                  data["building"]["address_postcode"] = data["address_postcode"]
                end
              end
            end
          end

          data["status_id"] ||= PENDING_REVIEW_STATUS_ID
          find("event_date").tap do |event_date|
            data["readable_id"] ||= "#{event_date.event_date.strftime('%y%m%d')}-#{data['event_name'].parameterize}"
          end

          data["name"] = data["event_name"]

          data["provider_website_url"] = data["event_website"]
          data["provider_target_audience"] = data["target_audience"]
          data["provider_organiser"] = data["organisation_name"]
          data["provider_contact_email"] = data["email"]

          find("registration_details").tap do |registration_details|
            if registration_details.website?
              data["registration_email_link"] = data["registration_website"]
            elsif registration_details.email?
              data["registration_email_link"] = data["registration_email"]
            end
          end

          data["start_at"] = data["start_time"]
          data["end_at"] = data["end_time"]
        end

        # accessibility
      end
    end

    def to_api_event(data)
      GetIntoTeachingApiClient::TeachingEvent.new(data)
      # api_event.building = building.to_api_building if building.present?
    end
  end
end
