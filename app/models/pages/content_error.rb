module Pages
  class ContentError < RuntimeError
    attr_reader :anchor

    def initialize(message, anchor)
      @anchor = anchor

      super(message)
    end
  end
end
