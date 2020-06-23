Date::DATE_FORMATS[:govuk] = "%d %B %Y"
Date::DATE_FORMATS[:default] = "%d %B %Y"
Date::DATE_FORMATS[:yearmonth] = "%Y-%m"
Date::DATE_FORMATS[:humanmonthyear] = "%B %Y"
Date::DATE_FORMATS[:long] = ->(d) { d.strftime "%-d#{d.day.ordinal} %B %Y" }
