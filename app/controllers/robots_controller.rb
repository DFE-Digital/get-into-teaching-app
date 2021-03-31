class RobotsController < ApplicationController
  layout :none

  # we're serving this from here rather than /public so we can apply any
  # redirects from beta-getintoteaching.education.gov.uk to
  # getintoteaching.education.gov.uk - hopefully preventing any search
  # engines from indexing the site under the beta domain
  def show
    render plain: <<~ROBOTS
      User-agent: *
      Disallow: /

      User-agent: SemrushBot-SA
      Allow: /

      User-agent: AhrefsSiteAudit
      Allow: /
    ROBOTS
  end
end
