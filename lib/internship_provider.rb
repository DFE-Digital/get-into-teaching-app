class InternshipProvider
  attr_reader :region

  def initialize(data)
    @data = data

    data.tap do |d|
      @school_name = d["school_name"]
      @region = d["region"]
      @school_website = d["school_website"]
      @contact_name = d["contact_name"]
      @contact_email = d["contact_email"]
      @subjects = d["subjects"]
    end
  end

  def to_h
    {
      "header" => @school_name.strip,
      "link" => @school_website.strip,
      "name" => @contact_name.strip,
      "email" => @contact_email.strip,
      "subjects" => @subjects.strip,
    }
  end

  def to_str
    [@name, @email, @city, @postcode, @region].join("|")
  end
end
