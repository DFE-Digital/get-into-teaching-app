module Middleware
  class DfeAnalytics
    def initialize(app, path, index: "index", headers: {})
      @app = app
      @file_handler = ActionDispatch::FileHandler.new(path, index: index, headers: headers)
    end

    def call(env)
      # Detect if page is Cached and send request event accordingly
      send_request_event(env) if @file_handler.attempt(env)

      @app.call(env)
    end

  private

    def send_request_event(env)
      request = ActionDispatch::Request.new(env)

      request_event = DfE::Analytics::Event.new
                                           .with_type("web_request")
                                           .with_request_details(request)
                                           .with_response_details(response)
                                           .with_request_uuid(request.request_id)

      DfE::Analytics::SendEvents.do([request_event.as_json])
    end

    def response
      ActionDispatch::Response.new(200, "Content-Type" => "text/html")
    end
  end
end
