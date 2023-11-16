class InternshipProvider
  attr_reader :region

  def initialize(data)
    @data = data

    data.tap do |d|
      @school_name = d[0] # TODO: Currently errors if this is string key. Investigate and fix.
      @region = d["region"]
      @school_website = d["school_website"]
      @contact_name = d["contact_name"]
      @contact_email = d["contact_email"]
      @subjects = d["subjects"]
      @areas = d["areas"]
      @applications = d["applications"]
      @full = ActiveModel::Type::Boolean.new.cast(d["full"])
    end
  end

  def to_h
    {
      "header" => @school_name.strip,
      "link" => @school_website.strip,
      "subjects" => @subjects.strip,
    }.tap do |h|
      if @full
        h["status"] = "Course full"
      else
        h["areas"] = @areas.strip if @areas
        h["applications"] = @applications.strip if @applications
        h["name"] = @contact_name.strip
        h["email"] = @contact_email.strip
      end
    end
  end

  def to_str
    [@name, @email, @city, @postcode, @region].join("|")
  end
end
