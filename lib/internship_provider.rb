require "active_model/type"

class InternshipProvider
  attr_reader :school_name, :region, :school_website,
              :contact_name, :contact_email,
              :subjects, :areas, :applications, :full

  def initialize(data)
    @data = data

    data.tap do |d|
      @school_name = d[0]&.strip
      @region = d["region"]&.strip
      @school_website = d["school_website"]&.strip
      @contact_name = d["contact_name"]&.strip
      @contact_email = d["contact_email"]&.strip
      @subjects = d["subjects"]&.strip
      @areas = d["areas"]&.strip
      @applications = d["applications"]&.strip
      @full = ActiveModel::Type::Boolean.new.cast(d["full"]&.strip)
    end
  end

  def to_h
    {
      "header" => @school_name,
      "link" => @school_website,
      "subjects" => @subjects,
    }.tap do |h|
      if @full
        h["status"] = "Course full"
      else
        h["areas"] = @areas
        h["applications"] = @applications
        h["name"] = @contact_name
        h["email"] = @contact_email
      end
    end
  end

  def to_str
    [@school_name, @areas, @region, @school_website, @contact_email].join("|")
  end
end
