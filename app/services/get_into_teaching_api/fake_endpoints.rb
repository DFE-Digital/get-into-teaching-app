module GetIntoTeachingApi
  module FakeEndpoints
    ENDPOINTS = {
      "teaching_events/86262bdc-07d7-4f40-b368-9c46cdd354b8" => :fake_event1,
      "teaching_events/c4c4ecc1-19d4-41f2-b9dc-f8c882886f3c" => :fake_event2,
      "teaching_events/search" => :fake_search,
      "teaching_events/upcoming" => :fake_upcoming,
      "types/teaching_event/types" => :fake_event_types,
    }.freeze

  private

    def data
      if ENDPOINTS[path]
        send ENDPOINTS[path]
      else
        super
      end
    end

    def fake_event1
      fake_event "86262bdc-07d7-4f40-b368-9c46cdd354b8"
    end

    def fake_event2
      fake_event "c4c4ecc1-19d4-41f2-b9dc-f8c882886f3c"
    end

    def fake_search
      (1..7).map { fake_event }
    end

    def fake_upcoming
      [
        fake_event("86262bdc-07d7-4f40-b368-9c46cdd354b8"),
        fake_event("c4c4ecc1-19d4-41f2-b9dc-f8c882886f3c"),
      ]
    end

    def fake_event(id = SecureRandom.uuid, startat = "2020-05-18T10:00:00+01:00")
      {
        "id": id,
        "typeId": 222_750_001,
        "name": "Event #{id.slice(0, 8)}",
        "description": "Description for event #{id}",
        "startAt": startat,
        "endAt": startat,
        "eventType": 0,
        "maxCapacity": 10,
        "publicEventUrl": "https://event.url",
        "building": {
          "id": SecureRandom.uuid,
          "accessibleToilets": true,
          "additionalFacilities": "string",
          "addressComposite": "Line 1, Line 2",
          "addressLine1": "Line 1",
          "addressLine2": "Line 2",
          "addressLine3": nil,
          "city": "Manchestr",
          "stateProvince": "Greater Manchester",
          "country": "United Kingdom",
          "postalCode": "MA1 1AM",
          "description": "Main Lecture Halls Building",
          "disabledAccess": true,
          "disabledParking": true,
          "publicTelephoneAvailable": true,
          "email": "first@someone.com",
          "name": "First Contact",
          "telephone1": "01234567890",
          "telephone2": nil,
          "telephone3": nil,
          "website": nil,
          "wifiAvailable": true,
        },
        "room": {
          "id": SecureRandom.uuid,
          "description": "Lecture Hall 1",
          "name": "Lecture Hall 1",
          "disabledAccess": true,
        },
      }
    end

    def fake_event_types
      (1..4).map { |i| { "id" => i, "value" => "Event type #{i}" } }
    end
  end
end
