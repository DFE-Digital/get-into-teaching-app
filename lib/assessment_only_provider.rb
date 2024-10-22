class AssessmentOnlyProvider
  attr_reader :provider, :regions, :website, :contact, :email, :phone

  def initialize(data)
    data.tap do |d|
      @provider = d[0]&.strip
      @regions = d["region"]&.split(/[;,|]+/)&.map(&:strip)
      @website = d["website"]&.strip
      @contact = d["contact"]&.strip
      @email = d["email"]&.strip
      @phone = d["phone"]&.strip
    end
  end

  def to_h
    {
      "header" => provider,
      "link" => website,
      "name" => contact,
      "email" => email,
      "telephone" => phone,
    }
  end

  def to_str
    [provider, regions&.join(";"), website, contact, email, phone].join("|")
  end
end
