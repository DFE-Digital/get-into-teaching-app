class RobotsController < ApplicationController
  layout :none

  def show
    render plain: <<~ROBOTS
      User-agent: *
      Disallow: /

      User-agent: SemrushBot-SA
      Allow: /
    ROBOTS
  end
end
