class URIChecker
  attr_reader :hostname, :scheme

  def initialize(uri)
    @hostname = uri.hostname
    @scheme = uri.scheme
  end

  def local_https?
    hostname == "localhost" && scheme == "https"
  end
end
