module RoutesIntoTeachingHelper
  def answers
    session[:routes_into_teaching]
  end

  def undergraduate_degree_summary
    {
      "Yes" => "have a degree",
      "No" => "do not have a degree",
      "Not yet" => "are studying for a degree",
    }[answers["undergraduate_degree"]]
  end

  def unqualified_teacher_summary
    {
      "Yes" => "have previously worked in a school",
      "No" => "haven't previously worked in a school",
    }[answers["unqualified_teacher"]]
  end

  def location_summary
    {
      "Yes" => "live in England",
      "No" => "do not live in England",
    }[answers["location"]]
  end

  def non_uk?
    answers["location"] == "No"
  end

  def no_degree?
    answers["undergraduate_degree"] == "No"
  end
end
