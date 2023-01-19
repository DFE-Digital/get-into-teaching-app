class Agency
  attr_reader :region

  def initialize(data)
    @data = data

    data.tap do |d|
      @name = d["Supplier Name"]
      @branch = d["Branch Name"]
      @email = d["Email"]
      @address1 = d["Address1"]
      @address2 = d["Address2"]
      @town = d["Town"]
      @county = d["County"]
      @postcode = d["Postcode"]
      @region = d["Region"]
      @phone = d["Phone"]
      @website = d["Website"]
    end
  end

  def to_h
    {
      "name" => @name,
      "email" => @email,
      "branch" => @branch,
      "phone" => @phone,
      "website" => @website,
      "address" => [@address1, @address2, @town, @county, @postcode]
        .compact
        .reject(&:blank?)
        .join(", "),
    }
  end

  def to_str
    [@name, @email, @city, @postcode, @region].join("|")
  end
end
