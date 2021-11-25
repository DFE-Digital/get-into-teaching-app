module Rack
  class DeflaterWithExclusions < Deflater
    def initialize(app, options = {})
      super

      @app = app

      @exclude = options[:exclude]
    end

    def call(env)
      if @exclude && @exclude.call(env)
        @app.call(env)
      else
        super(env)
      end
    end
  end
end
