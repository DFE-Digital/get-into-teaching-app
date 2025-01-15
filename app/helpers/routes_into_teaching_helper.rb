module RoutesIntoTeachingHelper
  def answers
    session[:routes_into_teaching]
  end

  def undergraduate_degree_summary
    case answers["undergraduate_degree"]
    when "Yes" then "have a degree"
    when "No" then "do not have a degree"
    when "Not yet" then "are studying for a degree"
    end
  end

  def unqualified_teacher_summary
    case answers["unqualified_teacher"]
    when "Yes" then "have previously worked in a school"
    when "No" then "haven't previously worked in a school"
    end
  end

  def location_summary
    case answers["location"]
    when "Yes" then "live in England"
    when "No" then "do not live in England"
    end
  end

  def non_uk?
    session.dig("routes_into_teaching", "location") == "No"
  end
end
