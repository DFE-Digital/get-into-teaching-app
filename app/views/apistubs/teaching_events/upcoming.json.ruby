 [
    {
      "eventId": (event_id = SecureRandom.uuid),
      "readableEventId": event_id,
      "eventName": "Become a teacher",
      "description": "Become a teacher",
      "startDate": "2020-05-18",
      "endDate": "2020-05-18",
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
        "wifiAvailable": true
      },
      "room": {
        "id": SecureRandom.uuid,
        "description": "Lecture Hall 1",
        "name": "Lecture Hall 1",
        "disabledAccess": true
      }
    }
  ].to_json
