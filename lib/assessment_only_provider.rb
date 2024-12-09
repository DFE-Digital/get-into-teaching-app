class AssessmentOnlyProvider
  attr_reader :provider, :regions, :website, :contact, :email, :phone, :international_phone, :extension

  def initialize(data)
    data.tap do |d|
      @provider = d[0]&.strip
      @regions = d["region"]&.split(/[;,|]+/)&.map(&:strip)
      @website = d["website"]&.strip
      @contact = d["contact"]&.strip
      @email = d["email"]&.strip
      @phone = d["phone"]&.strip
      @international_phone = d["international_phone"]&.strip
      @extension = d["extension"]&.strip
    end
  end

  def to_h
    {
      "header" => provider,
      "link" => website,
      "name" => contact,
      "email" => email,
      "telephone" => phone,
      "international_phone" => international_phone,
      "extension" => extension,
    }
  end

  def to_str
    [provider, regions&.join(";"), website, contact, email, phone, international_phone, extension].join("|")
  end
end
