require "active_model/type"

class InternshipProvider < Data.define(:school_name, :region, :school_website,
                                       :contact_name, :contact_email,
                                       :subjects, :areas, :applications, :full)

  def self.from_csv_row(row)
    new(
      school_name: row[0]&.strip, # NB: this is a positional argument (0) as the column name (school_name) doesn't seem to work for the first column in a csv file
      region: row["region"]&.strip,
      school_website: row["school_website"]&.strip,
      contact_name: row["contact_name"]&.strip,
      contact_email: row["contact_email"]&.strip,
      subjects: row["subjects"]&.strip,
      areas: row["areas"]&.strip,
      applications: row["applications"]&.strip,
      full: ActiveModel::Type::Boolean.new.cast(row["full"]&.strip),
    )
  end

  def to_h
    {
      "header" => school_name,
      "link" => school_website,
      "subjects" => subjects,
    }.tap do |h|
      if full
        h["status"] = "Course full"
      else
        h["areas"] = areas
        h["applications"] = applications
        h["name"] = contact_name
        h["email"] = contact_email
      end
    end
  end

  def to_str
    [school_name, areas, region, school_website, contact_email].join("|")
  end
end
