require "extensions/get_into_teaching_api_client/constants"
require "extensions/get_into_teaching_api_client/caching"

GetIntoTeachingApiClient::ApiClient.prepend Extensions::GetIntoTeachingApiClient::Caching
