module ProviderEvents
  class Wizard < ::GITWizard::Base
    DEFAULT_ERROR_MESSAGE = "Choose an option from the list".freeze


    PENDING_REVIEW_STATUS_ID = 222750003

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
    ]


    def complete!
      super.tap do |result|
        break unless result


        puts "EXPORT_DATA:"
        puts export_data.inspect

        puts "CONSTRUCT_EXPORT:"
        puts construct_export.inspect




        # attributes = GetIntoTeachingApiClient::TeacherTrainingAdviserSignUp.attribute_map.keys
        # attributes = GetIntoTeachingApiClient::TeachingEvent.attribute_map.keys
        #
        #
        # puts "@attributes:"
        # puts attributes.inspect
        #
        # hash = convert_attributes_for_api_model.slice(*attributes.map(&:to_s))
        # puts "HASH: #{hash.inspect}"

        # @event = Event.new(event_params)

        # puts to_api_event.inspect



        # request = GetIntoTeachingApiClient::TeachingEventsApi.new()
        #
        # request = GetIntoTeachingApiClient::MailingListAddMember.new(construct_export)
        #
        #
        #
        # @event = Event.new(event_params)
        # @event.assign_building(building_params) unless @event.online_event?
        #
        # if @event.save
        #   Rails.logger.info("#{@user.username} - create/update - #{@event.to_api_event.to_json}")
        #   redirect_to internal_events_path(
        #                 status: :pending,
        #                 readable_id: @event.readable_id,
        #                 event_type: determine_event_type_from_id(@event.type_id),
        #                 )
        # # else
        # #   render action: :new
        # end


        # @store[:reference_number] = "COMING-SOON"
        # @store.prune!(leave: ATTRIBUTES_TO_LEAVE)
      end
    end

  private

    def construct_export
      attributes = GetIntoTeachingApiClient::TeachingEvent.attribute_map.keys

      puts "ATTRIBUTES"
      puts attributes.inspect

      puts "EXPORT_DATA"
      puts export_data.inspect
      puts "\n"
    end

    def export_data_to_api_params
      export_data.tap do |data|
        {
          id: nil,
          type_id: data["event_type"].inquiry.online? ? ONLINE_EVENT_TYPE_ID : SCHOOL_UNI_EVENT_TYPE_ID,
          status_id: PENDING_REVIEW_STATUS_ID,
          region_id: nil,
          readable_id: "#{data["event_date"]}",
          web_feed_id: nil,

          is_online: nil,
          is_in_person: nil,
          is_virtual: nil,

          name: data["event_name"],
          # summary: data["event_description"],
          # message: nil,
          description: data["event_description"],

          provider_website_url: data["event_website"],
          provider_target_audience: data["target_audience"],
          provider_organiser: data["organisation_name"],
          provider_contact_email: data["email"],

          start_at: data["start_time"],
          end_at: data["end_time"],

          building: nil,

          accessibility_options: nil,
        }
      end
    end


    def export_data
      super.tap do |data|
        find("event_type").tap do |event_type|
          data["type_id"] = event_type.api_id
          data["is_online"] = event_type.online?
          data["is_in_person"] = event_type.in_person?
          data["is_virtual"] = event_type.online?
        end
        data["status_id"] ||= PENDING_REVIEW_STATUS_ID
        find("event_date").tap do |event_date|
          data["readable_id"] ||= "#{event_date.event_date.strftime("%y%m%d")}-#{data["event_name"].parameterize}"
        end

        data["name"] = data["event_name"]
        # summary: data["XXXX"],
        # message: nil,
        data["description"] = data["event_description"]

        data["provider_website_url"] = data["event_website"]
        data["provider_target_audience"] = data["target_audience"]
        data["provider_organiser"] = data["organisation_name"]
        data["provider_contact_email"] = data["email"]

        data["start_at"] = data["start_time"]
        data["end_at"] = data["end_time"]

        data["building"] ||= {}

        # accessibility
      end
    end

    # def add_event_to_crm
    #   GetIntoTeachingApiClient::TeachingEventsApi.new.upsert_teaching_event(to_api_event)
    # end

    # def to_api_event
    #   attributes = *GetIntoTeachingApiClient::TeachingEvent.attribute_map.keys
    #
    #   puts "ATTRIBUTES - KEYS: #{attributes.inspect}"
    #
    #   hash = convert_attributes_for_api_model.slice(*attributes.map(&:to_s))
    #
    #   puts "HASH: #{hash.inspect}"
    #
    #   api_event = GetIntoTeachingApiClient::TeachingEvent.new(hash)
    #
    #   puts "API_EVENT: #{api_event.inspect}"
    #
    #   puts "BUILDING: #{building.inspect}"
    #
    #   api_event.building = building.to_api_building if building.present?
    #   api_event
    # end


  end
end
